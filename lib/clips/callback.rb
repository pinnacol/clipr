module Clips
  class Callback
    class << self
      def intern(*variables, &block)
        block ? new(block, variables) : nil
      end
    end
    
    attr_accessor :callback
    attr_accessor :variables
    
    def initialize(callback, variables=[])
      @callback = callback
      @variables = variables
    end
    
    def call(env, data_objects)
      data_objects.collect! {|obj| env.cast(obj) }
      callback.call(env, data_objects)
    end
    
    def to_s
      vars = [nil]
      variables.each {|var| vars << "?#{var}" }
      "(ruby-call #{object_id}#{vars.join(' ')})"
    end
  end
end