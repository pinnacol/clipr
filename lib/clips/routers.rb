module Clips
  class Routers
    include Api::Router
    
    def initialize(env)
      @env = env
      @routers = {}
    end
    
    def [](name)
      router(name) or raise("unknown router: #{name.inspect}")
    end
    
    def router(name)
      router, priority = @routers[name.to_s]
      router
    end
    
    def priority(name)
      router, priority = @routers[name.to_s]
      priority
    end
    
    def has?(name)
      @routers.has_key?(name.to_s)
    end
    
    def add(name, router, priority=20)
      name = name.to_s
      raise "router already exists: #{name}" if @routers.has_key?(name)
      
      if EnvAddRouter(@env.pointer, name, priority, *router.functions) == 0
        raise ApiError(:Router, :EnvAddRouter, "could not add router: #{name}")
      end
      
      # note storing the router itself is necessary to ensure the 
      @routers[name] = [router, priority]
      self
    end
    
    def rm(name)
      name = name.to_s
      EnvDeleteRouter(@env.pointer, name)
      @routers.delete(name)
      self
    end
    
    def list
      @routers.keys
    end
    
    def to_hash
      @routers.dup
    end
  end
end