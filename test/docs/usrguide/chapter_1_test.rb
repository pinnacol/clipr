require File.dirname(__FILE__) + "/../../test_helper"
require "clipr/env"

class Chapter1Test < Test::Unit::TestCase
  Env = Clipr::Env

  attr_reader :env
  
  def setup
    @env = Env.new
  end
  
  def test_assert_facts_and_clear
    facts = env.facts
    
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
end