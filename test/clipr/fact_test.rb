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
  # name test
  #
  
  def test_name_returns_defined_deftemplate_name
    env.build "(deftemplate animal (slot sound))"
    env.assert "(animal (sound quack))"
    
    dt = Fact.new(env, env.facts.get(1))
    assert_equal "animal", dt.name
  end
  
  def test_name_returns_implied_deftemplate_name
    env.assert "(a b c)"
    
    dt = Fact.new(env, env.facts.get(1))
    assert_equal "a", dt.name
  end
end