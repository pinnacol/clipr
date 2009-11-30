require 'clips/api'
require 'clips/construct'
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
    
    attr_reader :routers, :constructs
    
    # Initializes a new Env.
    def initialize(options={})
      @pointer = Environment.CreateEnvironment
      @routers = Routers.new(self)
      @constructs = {}
      
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
    def build(construct)
      unless built?(construct)
        content = construct.content
        router.capture('werror') do |device|
          unless Environment.EnvBuild(@pointer, content) == 1
            err = device.string
            err = "could not build: #{content}" if err.empty?
            raise err
          end
        end
        
        constructs[construct.sha] = construct
      end
      
      self
    end
    
    def built?(construct)
      constructs.has_key?(construct.sha)
    end
    
    def classes(options={})
      router.capture(DEFAULT_DEVICE) do |dev|
        Defclass.EnvListDefclasses(pointer, DEFAULT_DEVICE, nil)
        dev.string
      end
    end
    
    def facts(options={})
      options = options.merge(
        :start => -1,
        :end => -1,
        :max => -1
      )
      
      router.capture(DEFAULT_DEVICE) do |dev|
        Api::Fact.EnvFacts(pointer, DEFAULT_DEVICE, nil, options[:start], options[:end], options[:max])
        dev.string
      end
    end
    
    def save(file)
      Api::Fact.EnvSaveFacts(pointer, file, LOCAL_SAVE, nil)
    end
  end
end