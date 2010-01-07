require 'clipr/api'
require 'clipr/utils'
require 'clipr/construct'
require 'clipr/callback'

require 'clipr/rule'
require 'clipr/fact'
require 'clipr/ordered_fact'
require 'clipr/facts'
require 'clipr/defglobals'
require 'clipr/deftemplate'
require 'clipr/deftemplates'
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
        rescue(Router::ExitError)
          raise "unexpected router exit (#{$!.code})#{env.werrors}"
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
    include Api::Fact
    include Api::Types
    
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
      @env_ptr = CreateEnvironment()
      
      @defglobals = Defglobals.new(self)
      @deftemplates = Deftemplates.new(self)
      @facts = Facts.new(self)
      @routers = Routers.new(self)
      @routers.add(DEFAULT_ROUTER, Router.new(Router.strio_devices))
      
      # note this reference to callback must be maintained
      # to ensure the Proc isn't gc'ed.
      @callback = method(:callback)
      @callback_error = nil
      unless EnvDefineFunction2(env_ptr, CALLBACK, ?b, @callback, "EnvCallback", "1*ui") == 1
        raise ApiError.new(:Api, :EnvDefineFunction2, "could not register ruby callback")
      end
    end
    
    # Returns the pointer to the internal Environment wrapped by self.  Raises
    # an error if the pointer is unset (ie the env was closed).
    def env_ptr
      @env_ptr or raise("closed env")
    end
    
    # Returns the index for the environment.
    def index
      GetEnvironmentIndex(env_ptr)
    end
    
    # Returns the specified router; raises an error if no such router exists.
    def router(router_name=DEFAULT_ROUTER)
      routers[router_name]
    end
    
    # Closes self and deallocates all memory associated with self.
    def close
      return false if closed?
      
      unless DestroyEnvironment(@env_ptr)
        raise ApiError.new(:Environment, :DestroyEnvironment, "could not close environment")
      end
      
      @env_ptr = nil
      true
    end
    
    # Returns true if self has been closed (ie env_ptr is unset).
    def closed?
      @env_ptr.nil?
    end
    
    # A helper for Api methods that return a pointer.  This method yields
    # env_ptr to the block and returns the resulting pointer, or nil for the
    # NULL pointer (ie the pointer address == 0).
    def getptr
      ptr = yield(env_ptr)
      ptr.address == 0 ? nil : ptr
    end
    
    # A helper for Api methods that write information into a data object. This
    # method yields env_ptr and a DataObject to the block and returns the
    # DataObject.
    def get # :yields: env_ptr, data_object
      obj = DataObject.new
      yield(env_ptr, obj)
      obj
    end
    
    # A helper for Api methods that set information from a data object.  This
    # method writes the value into a new DataObject and yield the env_ptr and
    # the DataObject to the block.  Returns the DataObject.
    def set(value) # :yields: env_ptr, data_object
      attributes = case value
      when Symbol
        { :type  => SYMBOL, 
          :value => EnvAddSymbol(env_ptr, value.to_s)}
      when String
        { :type  => STRING,   
          :value => EnvAddSymbol(env_ptr, value)}
      when Fixnum
        { :type  => INTEGER, 
          :value => EnvAddLong(env_ptr, value)}
      when Float
        { :type  => FLOAT,   
          :value => EnvAddDouble(env_ptr, value)}
      else
        raise "non-primitive values are not supported yet!"
      end
      
      obj = DataObject.intern(attributes)
      yield(env_ptr, obj)
      obj
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
        yield(env_ptr, DEFAULT_DEVICE, nil)
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
        deft_ptr = EnvFactDeftemplate(env_ptr, fact_ptr)
        deftemplates.deftemplate(deft_ptr).new(self, fact_ptr)
      else
        data_object.value
      end
    end
    
    def template(name=nil, desc=nil, &block)
      build Fact.intern(name, desc, &block).construct_str
    end
    
    def rule(name=nil, desc=nil, &block)
      build Rule.intern(name, desc, &block).construct_str
    end
    
    ########## API ##########
    
    def clear
      EnvClear(env_ptr)
      deftemplates.clear
      self
    end
    
    def reset
      EnvReset(env_ptr)
      self
    end
    
    def run(n=-1)
      check_callback do
        Agenda::EnvRun(env_ptr, n)
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
        get do |env_ptr, obj|
          if EnvFunctionCall(env_ptr, function, arguments, obj) == 1
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
      if construct.respond_to?(:construct_str)
        construct = construct.construct_str
      end
      
      if EnvBuild(env_ptr, construct) == 0
        raise ApiError.new(:Environment, :EnvBuild, werrors) { "could not build: #{construct}" } 
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
      if getptr {|env_ptr| EnvAssertString(env_ptr, str) }.nil?
        unless werrors(false).empty?
          raise ApiError.new(:Fact, :EnvAssertString, werrors)
        end
      end
      
      self
    end
    
    def save(file)
      EnvSaveFacts(env_ptr, file, LOCAL_SAVE, nil)
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
    # calling env (equal to env_ptr) and is provided by CLIPS.
    #
    # The ruby-call function takes the object id of a callable object as its
    # first argument.  Subsequent arguments can be any variable; they will be
    # looked up as DataObject instances.  Callback looks up the callable
    # object and then invokes the following:
    #
    #   object.call(env, data_objects)
    #
    # Returns 1 if call returns truthy, or 0 otherwise (for false/nil).
    def callback(env_ptr)
      n = EnvRtnArgCount(env_ptr)
      raise(ArgumentError, "no block id given") if n < 1
    
      # lookup block
      obj = DataObject.new
      EnvRtnUnknown(env_ptr, 1, obj)
      block = ObjectSpace._id2ref(obj.contents)
    
      # collect args
      args = []
      2.upto(n) do |i|
        obj = DataObject.new
        EnvRtnUnknown(env_ptr, i, obj)
        args << obj
      end
    
      block.call(self, args) ? 1 : 0
      
    rescue(Exception)
      @callback_error = $!
      return(0)
    end
  end
end