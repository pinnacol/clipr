require File.dirname(__FILE__) + "/test_helper"
require "clips"

class ReadmeTest < Test::Unit::TestCase
  include Clips::Api
  
  class Animal < Clips::Deftemplate
    deftemplate "animal"
    slot :sound
  end
  
  class Quack < Clips::Defrule
    defrule "quack"
    lhs.match "animal", :sound do |env, sound|
      env.cast(sound[0]) == :quack
    end
    
    rhs.call do |env, args|
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
    
    Clips::Env.open do |env|
      assert_equal false, env.call(">", "1 2").value
    end
    
    ###
    
    env = Clips::Env.new
    facts = env.facts
    
    env.assert "(animal-is duck)"
    env.build  "(defrule duck (animal-is duck) => (assert (sound-is quack)))"
    assert_equal ["(initial-fact)", "(animal-is duck)"], facts.list

    env.run
    assert_equal ["(initial-fact)", "(animal-is duck)", "(sound-is quack)"], facts.list

    env.clear
    assert_equal ["(initial-fact)"], facts.list
    
    ###
    
    env.build(Animal)
    env.build(Quack)

    facts.assert(:animal, {:sound => :quack})
    env.run
    assert_equal ["(initial-fact)", "(animal (sound quack))", "(sound-was quack)"], facts.list
  end
end