module Clips
  class Defrule
    class Test
      attr_accessor :callback
      attr_accessor :variables
      
      def initialize(callback, variables=[])
        @callback = Callback.new(callback)
        @variables = variables
      end
      
      def to_s
        vars = [nil]
        variables.each {|var| vars << "?#{var}" }
        
        "(test (ruby-call #{callback.object_id}#{vars.join(' ')}))"
      end
    end
  end
end