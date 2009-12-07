require 'clips/defrule/action'
require 'clips/defrule/conditions'

module Clips
  class Defrule
    class << self
      include Construct
      
      attr_reader :actions
      attr_reader :conditions
      
      def str
        condition_defs = conditions.collect {|condition| condition.to_s }
        action_defs = actions.collect {|action| action.to_s }
        
        "(defrule #{name} \"#{description}\" #{condition_defs.join(' ')} => #{action_defs.join(' ')})"
      end
      
      def call(env_ptr, data_objects)
        self.new.call(Env.cast(ptr, data_objects))
      end
      
      protected
      
      private

      def inherited(base)
        unless base.instance_variable_defined?(:@conditions)
          base.instance_variable_set(:@conditions, [])
        end
        
        unless base.instance_variable_defined?(:@actions)
          base.instance_variable_set(:@actions, [])
        end
        
        super
      end
    end
    
    def call(args)
      raise NotImplementedError
    end
  end
end