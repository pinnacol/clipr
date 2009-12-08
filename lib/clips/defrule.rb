require 'clips/defrule/actions'
require 'clips/defrule/conditions'

module Clips
  class Defrule
    class << self
      include Construct
      
      attr_reader :actions
      attr_reader :conditions
      
      def str
        desc = description.to_s.empty? ? " " : " \"#{description}\" "
        "(defrule #{name}#{desc}#{conditions.to_s} => #{actions.to_s})"
      end
      
      def call(ptr, data_objects)
        env = Env.get(ptr)
        data_objects.collect! {|obj| env.cast(obj) }
        
        self.new.call(env, data_objects)
      end
      
      protected
      
      def defrule(name)
        @name = name
      end
      
      def lhs(&block)
        conditions.instance_eval(&block) if block_given?
        conditions
      end
      
      def rhs(&block)
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
    
    def call(env, args)
    end
  end
end