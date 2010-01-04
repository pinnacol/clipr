require 'clipr/api'
require 'clipr/utils'
require 'clipr/construct'
require 'clipr/callback'

require 'clipr/defrule'
require 'clipr/deftemplate'
require 'clipr/deftemplates'
require 'clipr/defglobals'
require 'clipr/facts'
require 'clipr/router'
require 'clipr/routers'

module Clipr
  
  # ==== Error Checking
  #
  # Most Api methods will write to werror when they fail, so typically this
  # pattern will report the relevant error message:
  #
  #   if Api::ModuleName::FunctionName == :fail
  #     raise ApiError.new(:ModuleName, :FunctionName, env.werrors)
  #   end
  #
  # It is possible for this pattern to report error messages from previous,
  # unchecked failures.  A slower but more reliable pattern for capturing
  # error messages is:
  #
  #   env.router.capture('werror') do |device|
  #     if Api::ModuleName::FunctionName == :fail
  #       raise ApiError.new(:ModuleName, :FunctionName, device.string)
  #     end
  #   end
  #
  # Clipr generally uses the first, quicker pattern.
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
      
      def lambda(&block)
        Kernel.lambda do |env, data_objects|
          data_objects.collect! {|obj| env.cast(obj) }
          block.call(env, *data_objects)
        end
      end
    end
    
    include Api
    include Api::Environment
    
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
    
    # The external function in CLIPS for callbacks to Ruby.
    CALLBACK = "ruby-call"
    
    # Returns the Defglobals for self.
    attr_reader :defglobals
    
    # Returns the Deftemplates for self.
    attr_reader :deftemplates
    
    # Returns the Facts for self.
    attr_reader :facts
    
    # Returns the Routers for self.
    attr_reader :routers
    
    # Initializes a new Env.
    def initialize(options={})
      @pointer = CreateEnvironment()
      
      @defglobals = Defglobals.new(self)
      @deftemplates = Deftemplates.new(self)
      @facts = Facts.new(self)
      @routers = Routers.new(self)
      @routers.add(DEFAULT_ROUTER, Router.new(Router.strio_devices))
      
      # note this reference to callback must be maintained
      # to ensure the Proc isn't gc'ed.
      @callback = method(:callback)
      @callback_error = nil
      unless EnvDefineFunction2(pointer, CALLBACK, ?b, @callback, "EnvCallback", "1*ui") == 1
        raise ApiError.new(:Api, :EnvDefineFunction2, "could not register ruby callback")
      end
    end
    
    # Returns the pointer to the internal Environment wrapped by self.  Raises
    # an error if the pointer is unset (ie the env was closed).
    def pointer
      @pointer or raise("closed env")
    end
    
    # Returns the index for the environment.
    def index
      GetEnvironmentIndex(pointer)
    end
    
    # Returns the specified router; raises an error if no such router exists.
    def router(router_name=DEFAULT_ROUTER)
      routers[router_name]
    end
    
    # Closes self and deallocates all memory associated with self.
    def close
      return false if closed?
      
      unless DestroyEnvironment(@pointer)
        raise ApiError.new(:Environment, :DestroyEnvironment, "could not close environment")
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
        { :type  => SYMBOL, 
          :value => EnvAddSymbol(pointer, value.to_s)}
      when String
        { :type  => STRING,   
          :value => EnvAddSymbol(pointer, value)}
      when Fixnum
        { :type  => INTEGER, 
          :value => EnvAddLong(pointer, value)}
      when Float
        { :type  => FLOAT,   
          :value => EnvAddDouble(pointer, value)}
      else
        raise "non-primitive values are not supported yet!"
      end
      
      obj = DataObject.intern(attributes)
      yield(pointer, obj)
      obj
    end
    
    def getptr
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
    
    # Returns the content of the werrors device on the default router, and
    # clears if specified.
    def werrors(clear=true)
      device = router[:werror]
      errors = device.string
      device.string = "" if clear
      errors
    end
    
    def cast(data_object)
      if data_object[:type] == FACT_ADDRESS
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
      EnvClear(pointer)
      deftemplates.clear
      self
    end
    
    def reset
      EnvReset(pointer)
      self
    end
    
    def run(n=-1)
      check_callback do
        Agenda::EnvRun(pointer, n)
      end
    end
    
    # Calls the function with the arguments and returns the resulting
    # DataObject. Provides similar functionality to:
    #
    #   CLIPS> (function arguments...)
    #
    # Only functions may be called through this method (see build and
    # assert for building constructs and asserting facts from strings).
    def call(function, arguments=nil)
      check_callback do
        get do |ptr, obj|
          if EnvFunctionCall(ptr, function, arguments, obj) == 1
            raise ApiError.new(:Environment, :EnvFunctionCall, werrors) { "error in function: #{function}" }
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
    def build(construct)
      str = construct.respond_to?(:str) ? construct.str : construct.to_s
      if EnvBuild(pointer, str) == 0
        raise ApiError.new(:Environment, :EnvBuild, werrors) { "could not build: #{str}" } 
      end
      
      self
    end
    
    # Asserts the fact indicated by str and returns self.  Provides similar
    # functionality to:
    #
    #   CLIPS> (assert (str...))
    #
    # Note that only a single fact can be asserted at a time.
    #
    #   env.assert "(a)"
    #   env.assert "(b)"
    #   env.assert "(c)"
    #   env.facts.to_a             # => ["(initial-fact)", "(a)", "(b)", "(c)"]
    #
    #   env.clear
    #   env.assert "(a) (b) (c)"
    #   env.facts.to_a             # => ["(initial-fact)", "(a)"]
    #
    def assert(str)
      if getptr {|ptr| Fact::EnvAssertString(ptr, str) }.nil?
        unless werrors(false).empty?
          raise ApiError.new(:Fact, :EnvAssertString, werrors)
        end
      end
      
      self
    end
    
    def save(file)
      Fact::EnvSaveFacts(pointer, file, LOCAL_SAVE, nil)
    end
    
    private
    
    def check_callback # :nodoc:
      result = yield
      
      unless @callback_error.nil?
        err = @callback_error
        @callback_error = nil
        raise err
      end
      
      result
    end
    
    # Callback recieves inputs sent to the ruby-call external function that
    # Clipr registers with the CLIPS runtime.  The input is a pointer to the
    # calling env (equal to self.pointer) and is provided by CLIPS.
    #
    # The ruby-call function takes the object id of a callable object as its
    # first argument.  Subsequent arguments can be any variable; they will be
    # looked up as DataObject instances.  Callback looks up the callable
    # object and then invokes the following:
    #
    #   object.call(env, data_objects)
    #
    # Returns 1 if call returns truthy, or 0 otherwise (for false/nil).
    def callback(ptr)
      n = EnvRtnArgCount(ptr)
      raise(ArgumentError, "no block id given") if n < 1
    
      # lookup block
      obj = DataObject.new
      EnvRtnUnknown(ptr, 1, obj)
      block = ObjectSpace._id2ref(obj.contents)
    
      # collect args
      args = []
      2.upto(n) do |i|
        obj = DataObject.new
        EnvRtnUnknown(ptr, i, obj)
        args << obj
      end
    
      block.call(self, args) ? 1 : 0
      
    rescue(Exception)
      @callback_error = $!
      return(0)
    end
  end
end