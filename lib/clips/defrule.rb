require 'clips/defrule/actions'
require 'clips/defrule/conditions'

module Clips
  class Defrule
    class << self
      include Construct
      
      attr_reader :actions
      attr_reader :conditions
      
      def intern(name, description=nil, &block)
        rule = Class.new(self)
        rule.instance_variable_set(:@name, name)
        rule.instance_variable_set(:@description, description)
        rule.instance_eval(&block)
        rule
      end
      
      def str
        desc = description.to_s.empty? ? " " : " \"#{description}\" "
        "(defrule #{name}#{desc}#{conditions.to_s} => #{actions.to_s})"
      end
      
      def call(env_ptr, data_objects)
        self.new.call(Env.cast(ptr, data_objects))
      end
      
      protected
      
      def lhs(&block)
        conditions.instance_eval(&block) if block_given?
        conditions
      end
      
      def rhs
        actions.instance_eval(&block) if block_given?
        actions
      end
      
      private

      def inherited(base)
        unless base.instance_variable_defined?(:@conditions)
          base.instance_variable_set(:@conditions, Conditions.new)
        end
        
        unless base.instance_variable_defined?(:@actions)
          base.instance_variable_set(:@actions, Actions.new(base))
        end
        
        super
      end
    end
    
    def call(args)
      raise NotImplementedError
    end
  end
end