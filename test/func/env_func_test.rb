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
    slot :key, 'value'
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
  
  #
  # casting
  #
  
  def test_casting_from_callback
    was_in_block = false
    block = lambda do |env_ptr, data_objects|
      fact_data_object = data_objects[0]
      
      callback_env = Env.get(env_ptr)
      fact = callback_env.cast(fact_data_object)
      
      assert_equal env.object_id, callback_env.object_id
      assert_equal Clips::Deftemplate, fact.class
      assert_equal :alt, fact[:key].value
      
      was_in_block = true
    end
    
    env.build  "(deftemplate example (slot key))"
    env.build  "(defrule key-is-alt ?fact <- (example (key alt)) => (ruby-call #{block.object_id} ?fact))"
    env.assert "(example (key alt))"
    env.run
    
    assert_equal true, was_in_block
  end
  
  def test_casting_from_callback_with_deftemplate_class
    env.deftemplates.build(ExampleTemplate)
    
    was_in_block = false
    block = lambda do |env_ptr, data_objects|
      fact_data_object = data_objects[0]
      
      callback_env = Env.get(env_ptr)
      fact = callback_env.cast(fact_data_object)
      
      assert_equal env.object_id, callback_env.object_id
      assert_equal ExampleTemplate, fact.class
      assert_equal :alt, fact[:key].value
      
      was_in_block = true
    end
    
    env.build  "(defrule key-is-alt ?fact <- (example (key alt)) => (ruby-call #{block.object_id} ?fact))"
    env.assert "(example (key alt))"
    env.run
    
    assert_equal true, was_in_block
  end
end