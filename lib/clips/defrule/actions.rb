require 'clips/defrule/action'

module Clips
  class Defrule
    class Actions
      class << self
        def intern(target=nil, &block)
          actions = new(target)
          actions.instance_eval(&block) if block_given?
          actions
        end
      end
      
      attr_accessor :vars
      attr_accessor :actions
      
      def initialize(target=nil)
        @vars = nil
        @actions = []
        register(target)
      end
      
      def add(action)
        actions << action
        action
      end
      
      def register(target)
        target ? add(Action.new(target)) : nil
      end
      
      def call(&block)
        register(block)
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