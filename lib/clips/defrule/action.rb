module Clips
  class Defrule
    class Action
      attr_accessor :vars
      attr_accessor :target
      
      def initialize(target)
        @vars = nil
        @target = target
      end
      
      def to_s
        "(ruby-call #{target.object_id}#{vars})"
      end
    end
  end
end