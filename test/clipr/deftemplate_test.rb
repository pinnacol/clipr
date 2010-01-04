require File.dirname(__FILE__) + "/../test_helper"
require "clipr/env"

class DeftemplateTest < Test::Unit::TestCase
  acts_as_file_test
  Env = Clipr::Env
  Deftemplate = Clipr::Deftemplate

  attr_reader :env
  
  def setup
    super
    @env = Env.new
  end
  
  #
  # name test
  #
  
  def test_name_returns_defined_deftemplate_name
    env.build "(deftemplate animal (slot sound))"
    env.assert "(animal (sound quack))"
    
    dt = Deftemplate.new(env, env.facts.get(1))
    assert_equal "animal", dt.name
  end
  
  def test_name_returns_implied_deftemplate_name
    env.assert "(a b c)"
    
    dt = Deftemplate.new(env, env.facts.get(1))
    assert_equal "a", dt.name
  end
end