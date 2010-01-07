require File.dirname(__FILE__) + "/../test_helper"
require "clipr/env"

class TemplatesTest < Test::Unit::TestCase
  Env = Clipr::Env

  attr_reader :env
  
  def setup
    super
    @env = Env.new
  end
  
  class Example < Clipr::Fact
    deftemplate "example"
    slot :key, :value
  end
  
  #
  # assertion
  #
  
  def test_assertion_of_facts_from_template
    env.deftemplates.build(Example)
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
  
  #
  # casting
  #
  
  def test_casting_from_callback
    was_in_block = false
    block = lambda do |callback_env, data_objects|
      fact_data_object = data_objects[0]
      fact = callback_env.cast(fact_data_object)
      
      assert_equal env.object_id, callback_env.object_id
      assert_equal Clipr::Fact, fact.class
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
    env.deftemplates.build(Example)
    
    was_in_block = false
    block = Env.lambda do |callback_env, fact|
      assert_equal Example, fact.class
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
end