require 'clips/defrule/condition'

module Clips
  class Defrule
    
    class Conditions
      class << self
        def intern(modifier=nil, &block)
          cond = new([], modifier)
          cond.instance_eval(&block) if block_given?
          cond
        end
      end
      
      attr_reader :conditions
      attr_reader :modifier
      attr_reader :test
      
      def initialize(conditions=[], modifier=nil, &test)
        @conditions = conditions
        @modifier = modifier
        @test = test
      end
      
      def match(deftemplate, *assignments, &block)
        constraints = case assignments.last
        when Hash  then assignments.pop.to_a
        when Array then assignments.pop
        else []
        end
        
        condition = Condition.intern(deftemplate) do
          constraints.each {|name, value| slot(name, equal(value)) }
          assign(*assignments)
          test(&block) if block_given?
        end

        conditions << condition
        condition
      end
      
      def assign(var, template, *slots)
        raise NotImplementedError
      end
      
      def check(&block)
        raise NotImplementedError
      end
      
      def any(&block)
        raise NotImplementedError
      end
      
      def all(&block)
        raise NotImplementedError
      end
      
      def exists(&block)
        raise NotImplementedError
      end
      
      def every(&block)
        raise NotImplementedError
      end
      
      def not_match(deftemplate, *slots, &block)
        raise NotImplementedError
      end
      
      def not_any(&block)
        raise NotImplementedError
      end
      
      def not_all(&block)
        raise NotImplementedError
      end
      
      def not_exists(&block)
        raise NotImplementedError
      end
      
      def not_every(&block)
        raise NotImplementedError
      end
      
      def variables
        variables = []
        conditions.each do |condition|
          case
          when condition.respond_to?(:variable)
            variables << condition.variable
          when condition.respond_to?(:variables)
            variables.concat(condition.variables)
          else
            next
          end
        end
        
        variables
      end
      
      def to_s
        str = conditions.collect do |condition|
          condition.to_s
        end.join(' ')
        
        str = "(#{modifier} #{str})" if modifier
        str = "#{str} (test (ruby-call #{test.object_id} #{variables.join(' ')}))" if test
        
        str
      end
    end
  end
end