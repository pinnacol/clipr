require 'clips/defrule/constraint'

module Clips
  class Defrule
    
    # Condition.new 'sample', :constraints => [Constraint ...], :assignments => [[:key, :var], :key, :key]
    class Condition
      class << self
        def intern(deftemplate, options={}, &block)
          cond = new(deftemplate, options)
          cond.instance_eval(&block) if block_given?
          cond
        end
      end
      
      attr_reader :deftemplate
      attr_reader :constraints
      attr_reader :assignments
      attr_reader :variable
      attr_reader :tests
      
      def initialize(deftemplate, options={}, &test)
        @deftemplate = deftemplate
        @constraints = options[:constraints]  || []
        @assignments = options[:assignments] || []
        @variable = options[:variable]
        
        @tests = []
        @tests << test if test
      end
      
      def slot(slot, *terms, &predicate)
        constraint = Constraint.new(slot, terms, &predicate)
        constraints << constraint
        constraint
      end
      
      def equal(*values)
        values.collect! {|value| value_str(value) }
      end
      
      def not_equal(*values)
        values.collect! {|value| "~#{value_str(value)}" }.join("&")
      end
      
      def assign(*assignments)
        @assignments.concat(assignments)
      end
      
      def test(&block)
        @tests << block
      end
      
      def to_s
        # note: nils are specified in array for formatting... for example to
        # make no conditions produce "(template)" vs "(template )"
        
        conditions = [nil]
        constraints.each do |constraint|
          conditions << constraint.to_s
        end
        
        vars = [nil]
        assignments.each do |slot, var|
          var ||= slot
          conditions << "(#{slot} ?#{var})"
          vars << "?#{var}"
        end
        vars = vars.join(' ')
        
        checks = [nil]
        tests.each do |test|
          checks << "(test (ruby-call #{test.object_id}#{vars}))"
        end
        
        assignment = variable ? "?#{variable} <- " : nil
        
        "#{assignment}(#{deftemplate}#{conditions.join(' ')})#{checks.join(' ')}"
      end
      
      protected
      
      def value_str(value) # :nodoc:
        case value
        when Symbol, Integer, Float
          value.to_s
        when String
          "\"#{value}\""
        else
          oid = value.object_id
          "?v#{oid}&:(ruby-equal #{oid} ?v#{oid})"
        end
      end
    end
  end
end