require 'clips/defrule/constraint'
require 'clips/defrule/test'

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
      include Utils
      
      attr_accessor :deftemplate
      attr_accessor :constraints
      attr_accessor :assignments
      attr_accessor :variable
      attr_accessor :tests
      
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
      
      def test(*vars, &block)
        test = Test.new(block, vars)
        @tests << test
        test
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
          checks << test.to_s
        end
        
        assignment = variable ? "?#{variable} <- " : nil
        
        "#{assignment}(#{deftemplate}#{conditions.join(' ')})#{checks.join(' ')}"
      end
      
      private
      
      def non_primitive_value_str(value) # :nodoc:
        oid = value.object_id
        "?v#{oid}&:(ruby-equal #{oid} ?v#{oid})"
      end
    end
  end
end