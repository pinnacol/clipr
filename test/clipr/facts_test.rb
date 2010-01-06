require File.dirname(__FILE__) + "/../test_helper"
require "clipr/env"

class FactsTest < Test::Unit::TestCase
  Env = Clipr::Env
  OrderedFact = Clipr::Deftemplates::OrderedFact
  Deftemplate = Clipr::Deftemplate
  
  attr_reader :env, :facts
  
  def setup
    @env = Env.new
    @facts = env.facts
  end
  
  #
  # AGET test
  #
  
  def test_AGET_provides_access_to_cast_facts
    env.build "(deftemplate animal (slot sound))"
    env.assert "(a 1 2.3 \"str\")"
    env.assert "(animal (sound quack))"
    
    assert_equal [:a, 1, 2.3, "str"], facts[1].to_a
    assert_equal :quack, facts[2][:sound]
  end
  
  #
  # enumerable test
  #
  
  def test_collect_yields_cast_facts
    env.build "(deftemplate animal (slot sound))"
    env.assert "(a 1 2.3 \"str\")"
    env.assert "(b)"
    env.assert "(c)"
    env.assert "(animal (sound quack))"
    
    assert_equal ["initial-fact", "a", "b", "c", "animal"], facts.collect {|fact| fact.name }
  end
  
  #
  # eql? == test
  #
  
  def test_facts_compare_to_arrays
    assert_equal true, env.facts.eql?(["(initial-fact)"])
    assert_equal true, (env.facts == ["(initial-fact)"])
    
    # note this has to be reversed!
    assert_equal env.facts, ["(initial-fact)"]
  end
end