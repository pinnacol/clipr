require 'clips/api'

module Clips
  class Env
    include Api
    
    def initialize
      Environment.InitializeEnvironment
      @current = Environment.GetCurrentEnvironment
    end
    
    def save(file)
      Fact.EnvSaveFacts(@current, file, LOCAL_SAVE, nil)
    end
  end
end