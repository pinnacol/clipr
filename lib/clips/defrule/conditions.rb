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
      
      attr_accessor :conditions
      attr_accessor :modifier
      attr_accessor :checks
      
      def initialize(conditions=[], modifier=nil, &check)
        @conditions = conditions
        @modifier = modifier
      end
      
      def add(condition)
        conditions << condition
        condition
      end
      
      def match(deftemplate, *assignments, &block)
        constraints = case assignments.last
        when Hash  then assignments.pop.to_a
        when Array then assignments.pop
        else []
        end
        
        cond = Condition.intern(deftemplate) do
          constraints.each {|name, value| slot(name, equal(value)) }
          assign(*assignments)
          test(*assignments, &block) if block_given?
        end

        add(cond)
      end
      
      # Same as match but evaluates the block as if interning a condition,
      # rather than as a test.
      def condition(deftemplate, *assignments, &block)
        cond = match(deftemplate, *assignments)
        cond.instance_eval(&block) if block
        cond
      end
      
      # Same as match but assigns matches to the variable.
      def assign(variable, deftemplate, *assignments, &block)
        cond = match(deftemplate, *assignments, &block)
        cond.variable = variable
        cond
      end
      
      def check(*vars, &block)
        return nil unless block
        
        test = Test.new(block, vars)
        conditions << test
        test
      end
      
      # 
      def any(&block)
        add Conditions.intern(:or, &block)
      end
      
      def all(&block)
        add Conditions.intern(:and, &block)
      end
      
      def exists(&block)
        add Conditions.intern(:exists, &block)
      end
      
      def not_match(deftemplate, *assignments, &block)
        cond = Conditions.intern(:not) { match(deftemplate, *assignments, &block) }
        add(cond)
      end
      
      def not_any(&block)
        cond = Conditions.intern(:not) { any(&block) }
        add(cond)
      end
      
      def not_all(&block)
        cond = Conditions.intern(:not) { all(&block) }
        add(cond)
      end
      
      def not_exists(&block)
        cond = Conditions.intern(:not) { exists(&block) }
        add(cond)
      end
      
      def variables(target=[])
        conditions.each do |condition|
          case
          when condition.respond_to?(:variable)
            target << condition.variable
          when condition.respond_to?(:variables)
            condition.variables(target)
          else
            next
          end
        end
        
        target
      end
      
      def to_s
        str = conditions.collect do |condition|
          condition.to_s
        end.join(' ')
        
        str = "(#{modifier} #{str})" if modifier
        str
      end
      
      def initialize_copy(orig)
        super
        @conditions = @conditions.dup
      end
    end
  end
end