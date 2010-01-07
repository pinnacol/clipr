module Clipr
  class Deftemplate
    include Api::Deftemplate
    
    attr_reader :env
    attr_reader :deft_ptr
    
    def initialize(env, deft_ptr)
      @env = env
      @deft_ptr = deft_ptr
    end
    
    def name
      Api::GetConstructNameString(deft_ptr)
    end
  end
end