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
    
    DEFAULT_ROUTER = 'default'
    DEFAULT_DEVICE = 'device'
    
    attr_reader :routers
    
    # Initializes a new Env.
    def initialize(options={})
      @pointer = Environment.CreateEnvironment
      @routers = Routers.new(self)
      
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
    
    # Builds the construct and returns self.
    def build(str)
      router.capture('werror') do |device|
        unless Environment.EnvBuild(@pointer, str) == 1
          err = device.string
          err = "could not build: #{str}" if err.empty?
          raise err
        end
      end
      
      self
    end
    
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
  end
end