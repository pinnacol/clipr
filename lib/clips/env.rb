require 'clips/api'

module Clips
  class Env
    include Api
    
    def initialize
      @current = Environment.CreateEnvironment
    end
    
    def save(file)
      Fact.EnvSaveFacts(@current, file, LOCAL_SAVE, nil)
    end
  end
end