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
  
  #
  # match pattern
  #
  
  class MatchPattern < WasInBlockRule
    lhs.match :example, :key => :value
  end
  
  def test_match_pattern
    env.build(MatchPattern)
    
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
  # block match pattern
  #
  
  class BlockMatchPattern < WasInBlockRule
    lhs.match :example, :key do |key|
      key == :value
    end
  end
  
  def test_block_match_pattern
    env.build(BlockMatchPattern)
    
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
end