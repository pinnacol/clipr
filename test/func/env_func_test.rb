require File.dirname(__FILE__) + "/../test_helper"
require "clips/env"

class EnvFuncTest < Test::Unit::TestCase
  acts_as_file_test
  
  Env = Clips::Env

  attr_reader :env
  
  def setup
    super
    @env = Env.new
  end
  
  #
  # assertion
  #
  
  class AssertTemplate < Clips::Deftemplate
    deftemplate "example"
    slot :key, 'value'
  end
  
  def test_assertion_of_facts_from_template
    env.deftemplates.build(AssertTemplate)
    env.facts.assert(:example, {})
    env.facts.assert(:example, {:key => :alt})
    env.facts.assert(:example, {:key => 'alt'})
    env.facts.assert(:example, {:key => 1})
    env.facts.assert(:example, {:key => 1.2})
    
    env.facts.assert(:example, {:key => :repeat})
    env.facts.assert(:example, {:key => :repeat})
    
    assert_equal [
      "(initial-fact)", 
      "(example (key value))", 
      "(example (key alt))",
      "(example (key \"alt\"))",
      "(example (key 1))",
      "(example (key 1.2))",
      "(example (key repeat))"
    ], env.facts.list
  end
end