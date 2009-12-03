require 'clips/api'
require 'clips/router'
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
    end
    
    include Api
    
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
    
    attr_reader :routers, :objects
    
    # Initializes a new Env.
    def initialize(options={})
      @pointer = Environment.CreateEnvironment
      @routers = Routers.new(self)
      @objects = {}
      
      unless @routers.has?(DEFAULT_ROUTER)
        @routers.add(DEFAULT_ROUTER, Router.new)
      end
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
      
      unless Environment.DestroyEnvironment(@pointer)
        raise ApiError(:Environment, :DestroyEnvironment, "could not close environment")
      end
      
      @pointer = nil
      true
    end
    
    # Returns true if self has been closed (ie the pointer is unset).
    def closed?
      @pointer.nil?
    end
    
    ########## API ##########
    
    def run(n=-1)
      Agenda::EnvRun(pointer, n)
    end
    
    # Calls the function with the arguments and returns the value of the
    # resulting DataObject. Provides similar functionality to:
    #
    #   CLIPS> (function arguments...)
    #
    # Only functions may be called through this method (see build_str and
    # assert_str for building constructs and asserting facts from strings).
    def call(function, arguments=nil)
      result = Api::DataObject.new
      
      router.capture('werror') do |device|
        if Environment::EnvFunctionCall(pointer, function, arguments, result) == 1
          err = device.string
          err = "error in function: #{function}" if err.empty?
          raise err
        end
      end
      
      result.value
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
        if Environment.EnvBuild(pointer, str) == 0
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
    
    def classes(options={})
      router.capture(DEFAULT_DEVICE) do |dev|
        Defclass.EnvListDefclasses(pointer, DEFAULT_DEVICE, nil)
        dev.string
      end
    end
    
    # Returns facts as a string, similar to:
    #
    #   CLIPS> (facts)
    #
    def facts(options={})
      options = options.merge(
        :start => -1,
        :end => -1,
        :max => -1
      )
      
      router.capture(DEFAULT_DEVICE) do |dev|
        Fact.EnvFacts(pointer, DEFAULT_DEVICE, nil, options[:start], options[:end], options[:max])
        dev.string
      end
    end
    
    def save(file)
      Fact.EnvSaveFacts(pointer, file, LOCAL_SAVE, nil)
    end
    
    private
    
    # Sets and returns pointer to a value
    def symbolize(value)
      case value
      when String, Symbol
        Environment::EnvAddSymbol(pointer, value.to_s)
      when Fixnum
        Environment::EnvAddLong(pointer, value)
      when Float
        Environment::EnvAddDouble(pointer, value)
      else
        objects[value.hash] = value
        Environment::EnvAddLong(pointer, value.hash)
      end
    end
    
    def each_module(name)
      nesting = name.split("::")
      base = nesting.pop
      nesting.each {|nest| yield(nest) }
      base
    end
    
  end
end