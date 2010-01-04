require File.dirname(__FILE__) + "/../../test_helper"
require "clipr/env"

class Chapter1Test < Test::Unit::TestCase
  Env = Clipr::Env

  attr_reader :env, :facts
  
  def setup
    @env = Env.new
    @facts = env.facts
  end
  
  def test_assert_facts_and_clear
    env.assert "(duck)"
    assert_equal [
      "(initial-fact)",
      "(duck)"
    ], facts.to_a
    
    env.assert "(quack)"
    assert_equal [
      "(initial-fact)",
      "(duck)",
      "(quack)"
    ], facts.to_a
    
    env.clear
    env.assert "(a)"
    env.assert "(b)"
    env.assert "(c)"
    assert_equal [
      "(initial-fact)",
      "(a)",
      "(b)",
      "(c)"
    ], facts.to_a
    
    assert_equal [
      "(a)",
      "(b)",
      "(c)"
    ], facts.to_a(1)
    
    assert_equal [
      "(b)",
      "(c)"
    ], facts.to_a(2)
    
    assert_equal [
      "(a)",
      "(b)"
    ], facts.to_a(1,2)
    
    assert_equal [
      "(a)",
      "(b)"
    ], facts.to_a(1,2)
    
    assert_equal [
      "(a)",
      "(b)"
    ], facts.to_a(1, 3, 2)
  end
  
  def test_various_inputs
    env.assert "(duck)"
    env.assert "(duck1)"
    env.assert "(duck_soup)"
    env.assert "(duck-soup)"
    env.assert "(duck1-1_soup-soup)"
    env.assert "(d!?#%^)"
    
    env.assert "(number 1)"
    env.assert "(x 1.5)"
    env.assert "(y -1)"
    env.assert "(z 65)"
    env.assert "(distance 3.5e5)"
    env.assert "(coordinates 1 3 2)"
    
    env.assert '(The duck says "Quack")'
    env.assert '(The     duck      says     "Quack"  )'
    env.assert '(
    The
    duck
    says
    "Quack" 
    )'
    
    assert_equal [
      "(initial-fact)",
      "(duck)",
      "(duck1)",
      "(duck_soup)",
      "(duck-soup)",
      "(duck1-1_soup-soup)",
      "(d!?#%^)",
      "(number 1)",
      "(x 1.5)",
      "(y -1)",
      "(z 65)",
      "(distance 350000.0)",
      "(coordinates 1 3 2)",
      '(The duck says "Quack")'
    ], facts.to_a
  end
  
  def test_retract_a_fact
    env.assert "(animal-is duck)"
    env.assert "(animal-sound quack)"
    env.assert '(The duck says "Quack")'
    
    assert_equal [
      "(initial-fact)",
      "(animal-is duck)",
      "(animal-sound quack)",
      '(The duck says "Quack")'
    ], facts.to_a
    
    env.retract(3)
    assert_equal [
      "(initial-fact)",
      "(animal-is duck)",
      "(animal-sound quack)"
    ], facts.to_a
    
    err = assert_raises(ApiError) { env.retract(3) }
    assert_equal "[PRNTUTIL1] Unable to find fact f-3.", err.message
    
    env.clear
    env.assert "(animal-is duck)"
    env.assert "(animal-sound quack)"
    env.assert '(The duck says "Quack")'
    env.retract(1, 3)
    assert_equal [
      "(initial-fact)",
      "(animal-sound quack)"
    ], facts.to_a
    
    env.clear
    env.assert "(animal-is duck)"
    env.assert "(animal-sound quack)"
    env.assert '(The duck says "Quack")'
    env.retract
    assert_equal [
      "(initial-fact)"
    ], facts.to_a
  end
  
end