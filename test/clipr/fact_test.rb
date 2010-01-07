require File.dirname(__FILE__) + "/../test_helper"
require "clipr/env"

class FactTest < Test::Unit::TestCase
  acts_as_file_test
  Env = Clipr::Env
  Fact = Clipr::Fact

  attr_reader :env
  
  def setup
    super
    @env = Env.new
  end
  
  #
  # deftemplate test
  #
  
  def test_deftemplate_returns_a_deftemplate_for_self
    env.build "(deftemplate animal (slot sound))"
    env.assert "(animal (sound quack))"
    
    fact = Fact.new(env, env.facts.get(1))
    assert_equal "animal", fact.deftemplate.name
  end
  
  def test_deftemplate_works_for_implied_deftemplates
    env.assert "(a b c)"
    
    fact = Fact.new(env, env.facts.get(1))
    assert_equal "a", fact.deftemplate.name
  end
end