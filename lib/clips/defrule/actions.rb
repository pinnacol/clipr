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
      
      attr_accessor :vars
      attr_accessor :actions
      
      def initialize
        @vars = nil
        @actions = []
      end
      
      def add(action)
        actions << action
        action
      end
      
      def register(target)
        target ? add(Action.new(target)) : nil
      end
      
      def assert(str)
        actions << "(assert #{str})"
      end
      
      def call(&block)
        register(block)
      end
      
      def callback(&block)
        register Env.lambda(&block)
      end
      
      def to_s
        actions.collect do |action|
          action.vars = vars if action.respond_to?(:vars=)
          action.to_s
        end.join(' ')
      end
    end
  end
end