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
    
    attr_reader :routers
    
    # Initializes a new Env.
    def initialize(options={})
      @pointer = Environment.CreateEnvironment
      @routers = Routers.new(self)
      
      unless options[:no_default_router]
        @routers.add(:default, Router.new(Router.strio_devices))
      end
    end
    
    # Returns the pointer to the internal Environment wrapped by self.  Raises
    # an error if the pointer is unset (ie the env was closed).
    def pointer
      @pointer or raise("closed env")
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
    
    def facts(options={})
      options = options.merge(
        :start => -1,
        :end => -1,
        :max => -1,
        :router => 'default',
        :device => 'stdout'
      )
      
      unless router = routers[options[:router]]
        raise "unknown router: #{options[:router]}"
      end
      
      unless device = router[options[:device]]
        raise "unknown device: #{options[:device]} (router: #{options[:router]})"
      end
      
      Fact.EnvFacts(pointer, options[:device], nil, options[:start], options[:end], options[:max])
      device
    end
    
    def save(file)
      Fact.EnvSaveFacts(pointer, file, LOCAL_SAVE, nil)
    end
  end
end