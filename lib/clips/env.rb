require 'clips/api'
require 'clips/router'

require 'clips/env/utils'
require 'clips/env/facts'
require 'clips/env/globals'
require 'clips/env/routers'

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
    end
    
    include Api
    
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
    
    attr_reader :facts
    attr_reader :globals
    attr_reader :routers
    
    # Initializes a new Env.
    def initialize(options={})
      @pointer = Environment::CreateEnvironment()
      
      @facts = Facts.new(self)
      @globals = Globals.new(self)
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
      
      unless Environment::DestroyEnvironment(@pointer)
        raise ApiError(:Environment, :DestroyEnvironment, "could not close environment")
      end
      
      @pointer = nil
      true
    end
    
    # Returns true if self has been closed (ie the pointer is unset).
    def closed?
      @pointer.nil?
    end
    
    # Gets a DataObject from the block
    def get
      obj = DataObject.new
      yield(pointer, obj)
      obj
    end
    
    # Sets a DataObject using the block
    def set(value)
      attributes = case value
      when Symbol
        { :type  => DataObject::SYMBOL, 
          :value => Environment::EnvAddSymbol(pointer, value.to_s)}
      when String
        { :type  => DataObject::STRING,   
          :value => Environment::EnvAddSymbol(pointer, value)}
      when Fixnum
        { :type  => DataObject::INTEGER, 
          :value => Environment::EnvAddLong(pointer, value)}
      when Float
        { :type  => DataObject::FLOAT,   
          :value => Environment::EnvAddDouble(pointer, value)}
      else
        raise "non-primitive values are not supported yet!"
      end
      
      obj = DataObject.intern(attributes)
      yield(pointer, obj)
      obj
    end
    
    def capture(options={})
      router.capture(DEFAULT_DEVICE) do |dev|
        yield(pointer, DEFAULT_DEVICE, nil)
        dev.string
      end
    end
    
    ########## API ##########
    
    def clear
      Environment::Clear(pointer)
      reset_global
      self
    end
    
    def reset
      Environment::Reset(pointer)
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
    # Only functions may be called through this method (see build_str and
    # assert_str for building constructs and asserting facts from strings).
    def call(function, arguments=nil)
      get do |ptr, obj|
        router.capture('werror') do |device|
          if Environment::EnvFunctionCall(ptr, function, arguments, obj) == 1
            err = device.string
            err = "error in function: #{function}" if err.empty?
            raise err
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
    # method (to assert fact strings see assert_str).
    def build_str(str)
      router.capture('werror') do |device|
        if Environment::EnvBuild(pointer, str) == 0
          err = device.string
          err = "could not build: #{str}" if err.empty?
          raise err
        end
      end
      
      self
    end
    
    # Asserts the fact indicated by str and returns self.  Provides similar
    # functionality to:
    #
    #   CLIPS> (assert (str...))
    #
    def assert_str(str)
      Fact::EnvAssertString(pointer, str)
      self
    end
    
    def save(file)
      Fact::EnvSaveFacts(pointer, file, LOCAL_SAVE, nil)
    end
    
    private
    
    # resets the global variable identifying self within CLIPS
    def reset_global # :nodoc:
      globals.set(GLOBAL, object_id)
    end
  end
end