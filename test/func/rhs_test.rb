require File.dirname(__FILE__) + "/../test_helper"
require "clips/env"

class RhsTest < Test::Unit::TestCase
  acts_as_file_test
  
  Env = Clips::Env
  attr_reader :env
  
  def setup
    super
    @env = Env.new
    env.build(ExampleTemplate)
  end
  
  class ExampleTemplate < Clips::Deftemplate
    deftemplate "example"
    slot :key, :value
  end
  
  class AssignmentRule < Clips::Defrule
    lhs.assign(:var, :example, :key => :value)
  end
  
  def assert_match
    env.facts.assert(:example, {:key => :value})
    env.run
    
    assert_equal [
      "(initial-fact)", 
      "(example (key value))",
      "(was in block)"
    ], env.facts.list
  end
  
  #
  # callback pattern
  #
  
  class CallbackPattern < AssignmentRule
    rhs.callback(:var) do |env, var|
      if var[:key] == :value
        env.assert("(was in block)")
      else
        env.assert("(wrong value)")
      end
    end
  end
  
  def test_callback_pattern
    env.build(CallbackPattern)
    assert_match
  end
  
  #
  # rule pattern
  #
  
  class RulePattern < AssignmentRule
    rhs.register(self, :var)
    
    def call(env, var)
      if var[:key] == :value
        env.assert("(was in block)")
      else
        env.assert("(wrong value)")
      end
    end
  end
  
  def test_rule_pattern
    env.build(RulePattern)
    assert_match
  end
end