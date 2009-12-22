require File.dirname(__FILE__) + "/../test_helper"
require "clips/env"

class PatternsTest < Test::Unit::TestCase
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
  
  class WasInBlockRule < Clips::Defrule
    rhs.register(self)
    def call(env, args)
      env.assert "(was in block)"
    end
  end
  
  def assert_match
    env.facts.assert(:example, {:key => :alt})
    env.run
    
    assert_equal [
      "(initial-fact)", 
      "(example (key alt))"
    ], env.facts.list
    
    env.facts.assert(:example, {:key => :value})
    env.run
    
    assert_equal [
      "(initial-fact)", 
      "(example (key alt))",
      "(example (key value))",
      "(was in block)"
    ], env.facts.list
  end
  
  #
  # match pattern
  #
  
  class MatchPattern < WasInBlockRule
    lhs.match :example, :key => :value
  end
  
  def test_match_pattern
    env.build(MatchPattern)
    assert_match
  end
  
  #
  # block match pattern
  #
  
  class BlockMatchPattern < WasInBlockRule
    lhs.match :example, :key do |key|
      key == :value
    end
  end
  
  def test_block_match_pattern
    env.build(BlockMatchPattern)
    assert_match
  end
  
  
  #
  # slot match pattern
  #
  
  class SlotMatchPattern < WasInBlockRule
    lhs.condition :example do
      slot :key, equal(:value)
    end
  end
  
  def test_slot_match_pattern
    env.build(SlotMatchPattern)
    assert_match
  end
  
  #
  # predicate match pattern
  #
  
  class PredicateMatchPattern < WasInBlockRule
    lhs.condition :example do
      slot(:key) {|key| key == :value }
    end
  end
  
  def test_predicate_match_pattern
    env.build(PredicateMatchPattern)
    assert_match
  end
  
  #
  # test match pattern
  #
  
  class TestMatchPattern < WasInBlockRule
    lhs.condition :example do
      assign :key
      test(:key) {|key| key == :value }
    end
  end
  
  def test_test_match_pattern
    env.build(TestMatchPattern)
    assert_match
  end
  
  #
  # check match pattern
  #
  
  class CheckMatchPattern < WasInBlockRule
    lhs.assign :var, :example
    lhs.check :var do |var|
      var[:key] == :value
    end
  end
  
  def test_check_match_pattern
    env.build(CheckMatchPattern)
    assert_match
  end
  
  #
  # all match pattern
  #
  
  class AllMatchPattern < WasInBlockRule
    lhs.all do
      match :example, :key => :value
      match :example, :key => :alt
    end
  end
  
  def test_all_match_pattern
    env.build(AllMatchPattern)
    assert_match
  end
  
  #
  # any match pattern
  #
  
  class AnyMatchPattern < WasInBlockRule
    lhs.any do
      match :example, :key => :value
      match :example, :key => :alt
    end
  end
  
  def test_any_match_pattern
    env.build(AnyMatchPattern)
    
    env.facts.assert(:example, {:key => :alt})
    env.run
    
    assert_equal [
      "(initial-fact)", 
      "(example (key alt))",
      "(was in block)"
    ], env.facts.list
    
    env.reset
    env.facts.assert(:example, {:key => :value})
    env.run
    
    assert_equal [
      "(initial-fact)", 
      "(example (key value))",
      "(was in block)"
    ], env.facts.list
  end
  
  #
  # not match pattern
  #
  
  class NotMatchPattern < WasInBlockRule
    lhs.not_match :example, :key => :value
  end
  
  def test_test_not_match_pattern
    env.build(NotMatchPattern)
    
    env.facts.assert(:example, {:key => :alt})
    env.run
    
    assert_equal [
      "(initial-fact)", 
      "(example (key alt))",
      "(was in block)"
    ], env.facts.list
    
    env.reset
    env.facts.assert(:example, {:key => :value})
    env.run
    
    assert_equal [
      "(initial-fact)",
      "(example (key value))"
    ], env.facts.list
  end
end