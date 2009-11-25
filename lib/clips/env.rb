require 'clips/api'

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
    
    # Initializes a new Env.
    def initialize
      @pointer = Environment.CreateEnvironment
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
        raise "failure in DestroyEnvironment"
      end
      
      @pointer = nil
      true
    end
    
    # Returns true if self has been closed (ie the pointer is unset).
    def closed?
      @pointer.nil?
    end
    
    ########## API ########## 
    
    def save(file)
      Fact.EnvSaveFacts(pointer, file, LOCAL_SAVE, nil)
    end
  end
end