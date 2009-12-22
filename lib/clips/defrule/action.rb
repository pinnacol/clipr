module Clips
  class Defrule
    class Action
      attr_accessor :callback
      attr_accessor :variables
      
      def initialize(callback, variables=[])
        @callback = callback
        @variables = variables
      end
      
      def call(env, data_objects)
        data_objects.collect! {|obj| env.cast(obj) }
        callback.call(env, *data_objects)
      end
      
      def to_s
        vars = [nil]
        variables.each {|var| vars << "?#{var}" } if variables
        
        "(ruby-call #{object_id}#{vars.join(' ')})"
      end
    end
  end
end