require 'clips/api'
require 'clips/utils'
require 'clips/construct'

require 'clips/defrule'
require 'clips/deftemplate'
require 'clips/deftemplates'
require 'clips/defglobals'
require 'clips/facts'
require 'clips/router'
require 'clips/routers'

module Clips
  class Env
    class << self
      
      # With no block open is a synonym for new.  If a block is given the new
      # env will be passed to it and closed when the block completes. In this
      # case the return of open is the block return value.
      def open
        env = new
        
        unless block_given?
          return env
        end
        
        begin
          yield(env)
        ensure
          env.close
        end
      end
      
      # Gets an Env instance based on a CLIPS Environment pointer.  This is
      # useful for looking up an Env from within an Api callback.
      def get(ptr)
        obj = Api::DataObject.new
        if Api::Defglobal::EnvGetDefglobalValue(ptr, GLOBAL, obj) == 0
          raise "could not find the #{GLOBAL} global"
        end
        
        ObjectSpace._id2ref(obj.value)
      end
      
      def cast(ptr, data_objects)
        env = get(ptr)
        [env, data_objects.collect! {|obj| env.cast(obj) }]
      end
      
      def lambda
        Kernel.lambda do |env_ptr, data_objects|
          env, objects = cast(env_ptr, data_objects)
          yield(env, *objects)
        end
      end
    end
    
    include Api
    include Api::Environment
    
    # The global variable used to store a backreference to the Env instance
    # within a CLIPS environment.  This variable can then be used to lookup
    # the Env instance within Api callbacks (see Env.get).
    GLOBAL = "clipsenv"
    
    # The default router.
    DEFAULT_ROUTER = 'default'
    
    # The default device (ie logical name) that receives captured output.
    #
    #--
    # DEFAULT_DEVICE is 'wdisplay' rather than something else because CLIPS
    # sometimes sends output to this device when it probably shouldn't; using
    # this device as the default ends up capturing all the output in most
    # cases.  (see gitgo b9e3ab796c00d99c3894949b57542cccc3da2ee3)
    DEFAULT_DEVICE = 'wdisplay'
    
    attr_reader :defglobals
    attr_reader :deftemplates
    attr_reader :facts
    attr_reader :routers
    
    # Initializes a new Env.
    def initialize(options={})
      @pointer = CreateEnvironment()
      
      @defglobals = Defglobals.new(self)
      @deftemplates = Deftemplates.new(self)
      @facts = Facts.new(self)
      @routers = Routers.new(self)
      
      unless @routers.has?(DEFAULT_ROUTER)
        @routers.add(DEFAULT_ROUTER, Router.new)
      end
      
      reset_global
    end
    
    # Returns the pointer to the internal Environment wrapped by self.  Raises
    # an error if the pointer is unset (ie the env was closed).
    def pointer
      @pointer or raise("closed env")
    end
    
    # Returns the specified router; raises an error if no such router exists.
    def router(router_name=DEFAULT_ROUTER)
      routers[router_name]
    end
    
    # Closes self and deallocates all memory associated with self.
    def close
      return false if closed?
      
      unless DestroyEnvironment(@pointer)
        raise ApiError(:Environment, :DestroyEnvironment, "could not close environment")
      end
      
      @pointer = nil
      true
    end
    
    # Returns true if self has been closed (ie the pointer is unset).
    def closed?
      @pointer.nil?
    end
    
    # Gets a DataObject from Api get methods.  Get methods have a signature
    # like this (ex GetDefglobalValue):
    #
    #   EnvGetSomething(theEnv, ..., &data_object)
    #
    # Get will yield the env and data object to the block.  Returns the data
    # object.
    def get # :yields: env_ptr, data_object
      obj = DataObject.new
      yield(pointer, obj)
      obj
    end
    
    # Sets up a DataObject for the value, for use with Api set methods.  Set
    # methods have a signature like this (ex EnvSetDefglobalValue):
    #
    #   EnvSetSomething(theEnv, ..., &data_object)
    #
    # Set will yield the env and data object to the block, where the data
    # object will be setup with the specified value.  Returns the data object.
    def set(value) # :yields: env_ptr, data_object
      attributes = case value
      when Symbol
        { :type  => DataObject::SYMBOL, 
          :value => EnvAddSymbol(pointer, value.to_s)}
      when String
        { :type  => DataObject::STRING,   
          :value => EnvAddSymbol(pointer, value)}
      when Fixnum
        { :type  => DataObject::INTEGER, 
          :value => EnvAddLong(pointer, value)}
      when Float
        { :type  => DataObject::FLOAT,   
          :value => EnvAddDouble(pointer, value)}
      else
        raise "non-primitive values are not supported yet!"
      end
      
      obj = DataObject.intern(attributes)
      yield(pointer, obj)
      obj
    end
    
    def find
      ptr = yield(pointer)
      ptr.address == 0 ? nil : ptr
    end
    
    # Captures output for Api printing methods.  Printing methods have a
    # signature like this (ex EnvListDefglobals):
    #    
    #   EnvDoSomething(theEnv, logicalName, theModule)
    #    
    # Capture will yield these three arguments to the block and return
    # whatever gets printed to the device.  Capture does not perform error
    # checking.
    def capture(options={}) # :yields: env_ptr, logical_name, module_name
      router.capture(DEFAULT_DEVICE) do |device|
        yield(pointer, DEFAULT_DEVICE, nil)
        device.string
      end
    end
    
    def cast(data_object)
      if data_object[:type] == DataObject::FACT_ADDRESS
        fact_ptr = data_object[:value]
        deft_ptr = Fact::EnvFactDeftemplate(pointer, fact_ptr)
        deftemplates.deftemplate(deft_ptr).new(self, fact_ptr)
      else
        data_object.value
      end
    end
    
    def template(name=nil, desc=nil, &block)
      build Deftemplate.intern(name, desc, &block).str
    end
    
    def rule(name=nil, desc=nil, &block)
      build Defrule.intern(name, desc, &block).str
    end
    
    ########## API ##########
    
    def clear
      Clear(pointer)
      reset_global
      self
    end
    
    def reset
      Reset(pointer)
      reset_global
      self
    end
    
    def run(n=-1)
      Agenda::EnvRun(pointer, n)
    end
    
    # Calls the function with the arguments and returns the resulting
    # DataObject. Provides similar functionality to:
    #
    #   CLIPS> (function arguments...)
    #
    # Only functions may be called through this method (see build and
    # assert for building constructs and asserting facts from strings).
    def call(function, arguments=nil)
      get do |ptr, obj|
        router.capture('werror') do |device|
          if EnvFunctionCall(ptr, function, arguments, obj) == 1
            msg = device.string
            msg = "error in function: #{function}" if msg.empty?
            raise ApiError.new(:Environment, :EnvFunctionCall, msg)
          end
        end
      end
    end
    
    # Builds the construct str and returns self.  Provides similar
    # functionality to:
    #
    #   CLIPS> (str...)
    #
    # Only constructs like deftemplate or defrule can be built through this
    # method (to assert fact strings see assert).
    def build(str)
      router.capture('werror') do |device|
        if EnvBuild(pointer, str) == 0
          msg = device.string
          msg = "could not build: #{str}" if msg.empty?
          raise ApiError.new(:Environment, :EnvBuild, msg)
        end
      end
      
      self
    end
    
    # Asserts the fact indicated by str and returns self.  Provides similar
    # functionality to:
    #
    #   CLIPS> (assert (str...))
    #
    def assert(str)
      Fact::EnvAssertString(pointer, str)
      self
    end
    
    def save(file)
      Fact::EnvSaveFacts(pointer, file, LOCAL_SAVE, nil)
    end
    
    private
    
    # resets the global variable identifying self within CLIPS
    def reset_global # :nodoc:
      defglobals.set(GLOBAL, object_id)
    end
  end
end