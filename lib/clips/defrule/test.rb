module Clips
  class Defrule
    class Test
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
        callback.call(*data_objects)
      end
      
      def to_s
        vars = [nil]
        variables.each {|var| vars << "?#{var}" }
        
        "(test (ruby-call #{object_id}#{vars.join(' ')}))"
      end
    end
  end
end