require 'clips/defrule/action'

module Clips
  class Defrule
    class Actions
      class << self
        def intern(&block)
          actions = new
          actions.instance_eval(&block) if block_given?
          actions
        end
      end
      
      attr_accessor :actions
      
      def initialize
        @actions = []
      end
      
      def add(action)
        actions << action
        action
      end
      
      def assert(str)
        actions << "(assert #{str})"
      end
      
      def callback(*variables, &callback)
        add Action.new(callback, variables)
      end
      
      def register(callback, *variables)
        add Callback.new(callback, variables)
      end
      
      def to_s
        actions.collect {|action| action.to_s }.join(' ')
      end
      
      def initialize_copy(orig)
        super
        @actions = @actions.dup
      end
    end
  end
end