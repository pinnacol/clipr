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
  
  class ExampleTemplate < Clips::Deftemplate
    deftemplate "example"
    slot :key, :value
  end
  
  #
  # assertion
  #
  
  def test_assertion_of_facts_from_template
    env.deftemplates.build(ExampleTemplate)
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
  
  def test_build_clear_rebuild
    env.deftemplates.build(ExampleTemplate)
    env.facts.assert(:example, {:key => :one})
    assert_equal ["(initial-fact)", "(example (key one))"], env.facts.list
    
    env.clear
    assert_equal ["(initial-fact)"], env.facts.list
    
    env.deftemplates.build(ExampleTemplate)
    env.facts.assert(:example, {:key => :two})
    assert_equal ["(initial-fact)", "(example (key two))"], env.facts.list
    
    env.clear
    assert_equal ["(initial-fact)"], env.facts.list
    
    env.deftemplates.build(ExampleTemplate)
    env.facts.assert(:example, {:key => :three})
    assert_equal ["(initial-fact)", "(example (key three))"], env.facts.list
  end
  
  def test_build_clear_rebuild_the_same_fact
    env.deftemplates.build(ExampleTemplate)
    env.facts.assert(:example, {})
    assert_equal ["(initial-fact)", "(example (key value))"], env.facts.list
    
    env.clear
    assert_equal ["(initial-fact)"], env.facts.list
    
    env.deftemplates.build(ExampleTemplate)
    env.facts.assert(:example, {})
    assert_equal ["(initial-fact)", "(example (key value))"], env.facts.list
    
    env.clear
    assert_equal ["(initial-fact)"], env.facts.list
    
    env.deftemplates.build(ExampleTemplate)
    env.facts.assert(:example, {})
    assert_equal ["(initial-fact)", "(example (key value))"], env.facts.list
  end
  
  #
  # casting
  #
  
  def test_casting_from_callback
    was_in_block = false
    block = lambda do |callback_env, data_objects|
      fact_data_object = data_objects[0]
      fact = callback_env.cast(fact_data_object)
      
      assert_equal env.object_id, callback_env.object_id
      assert_equal Clips::Deftemplate, fact.class
      assert_equal :alt, fact[:key]
      
      was_in_block = true
    end
    
    env.build  "(deftemplate example (slot key))"
    env.build  "(defrule key-is-alt ?fact <- (example (key alt)) => (ruby-call #{block.object_id} ?fact))"
    env.assert "(example (key alt))"
    env.run
    
    assert_equal true, was_in_block
  end
  
  def test_casting_callback_with_deftemplate_class
    env.deftemplates.build(ExampleTemplate)
    
    was_in_block = false
    block = Env.lambda do |callback_env, fact|
      assert_equal ExampleTemplate, fact.class
      assert_equal :alt, fact[:key]
      
      was_in_block = true
    end
    
    env.build  "(defrule key-is-alt ?fact <- (example (key alt)) => (ruby-call #{block.object_id} ?fact))"
    env.assert "(example (key alt))"
    env.run
    
    assert_equal true, was_in_block
  end
  
  def test_casting_callback_with_multiple_facts
    was_in_block = false
    block = Env.lambda do |callback_env, fact1, fact2|
      assert_equal :one, fact1[:key]
      assert_equal :two, fact2[:key]
      was_in_block = true
    end
    
    env.build  "(deftemplate example (slot key))"
    env.build  "(defrule key-is-alt ?one <- (example (key one)) ?two <- (example (key two)) => (ruby-call #{block.object_id} ?one ?two))"
    env.assert "(example (key one))"
    env.assert "(example (key two))"
    env.run
    
    assert_equal true, was_in_block
  end
  
  #
  # rules
  #
  
  class ExampleRule < Clips::Defrule
    lhs do
      match :example, :key => :value
    end
    
    rhs.register(self)
    
    def call(env, args)
      env.assert "(was in block - #{args.length})"
    end
  end
  
  def test_callback_to_rule
    env.build(ExampleTemplate.str)
    env.build(ExampleRule.str)
    
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
      "(was in block - 0)"
    ], env.facts.list
  end
end