require File.dirname(__FILE__) + "/test_helper"
require "clipr"

class ReadmeTest < Test::Unit::TestCase
  include Clipr::Api
  
  class Animal < Clipr::Fact
    deftemplate "animal"
    slot :sound
  end

  class Quack < Clipr::Rule
    defrule "quack"
    lhs.match "animal", :sound => :quack
    rhs.assert "(sound-was quack)"
  end
  
  class QuackCall < Clipr::Rule
    defrule "quack_call"
    
    lhs.match("animal", :sound) do |sound|
      sound == :quack
    end

    rhs.callback do |env|
      env.assert "(sound-was quack)"
    end
  end
  
  def test_readme
    env_ptr = Environment::CreateEnvironment()
  
    obj = DataObject.new
    Environment::EnvFunctionCall(env_ptr, ">", "1 2", obj)
  
    node = Struct::SymbolHashNode.new(obj[:value])
    assert_equal "FALSE", node[:contents]
    
    Environment::DestroyEnvironment(env_ptr)
    
    ###
    
    Clipr::Env.open do |env|
      assert_equal false, env.call(">", "1 2").value
    end
    
    ###
    
    env = Clipr::Env.new
    facts = env.facts
    
    env.assert "(animal-is duck)"
    env.build  "(defrule duck (animal-is duck) => (assert (sound-is quack)))"
    assert_equal ["(initial-fact)", "(animal-is duck)"], facts.list

    env.run
    assert_equal ["(initial-fact)", "(animal-is duck)", "(sound-is quack)"], facts.list

    env.clear
    assert_equal ["(initial-fact)"], facts.list
    
    ###
    
    assert_equal "(deftemplate animal (slot sound))", Animal.construct_str
    assert_equal "(defrule quack (animal (sound quack)) => (assert (sound-was quack)))", Quack.construct_str

    env.clear
    env.build(Animal)
    env.build(Quack)

    facts.assert(:animal, {:sound => :quack})
    env.run
    assert_equal ["(initial-fact)", "(animal (sound quack))", "(sound-was quack)"], facts.list
    
    ###
    
    lhs_block = QuackCall.conditions.conditions[0].tests[0]
    rhs_block = QuackCall.actions.actions[0]
    assert_equal "(defrule quack_call (animal (sound ?sound)) (test (ruby-call #{lhs_block.object_id} ?sound)) => (ruby-call #{rhs_block.object_id}))", QuackCall.construct_str

    env.clear
    env.build(Animal)
    env.build(QuackCall)

    facts.assert(:animal, {:sound => :quack})
    env.run
    assert_equal ["(initial-fact)", "(animal (sound quack))", "(sound-was quack)"], facts.list
  end
end