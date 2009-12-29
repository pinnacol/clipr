require File.dirname(__FILE__) + "/../test_helper"
require "clipr/env"

class FactsTest < Test::Unit::TestCase
  Env = Clipr::Env

  attr_reader :env, :facts
  
  def setup
    @env = Env.new
    @facts = env.facts
  end
  
  #
  # eql? == test
  #
  
  def test_facts_compare_to_arrays
    assert_equal true, env.facts.eql?(["(initial-fact)"])
    assert_equal true, (env.facts == ["(initial-fact)"])
    
    # note this has to be reversed!
    assert_equal env.facts, ["(initial-fact)"]
  end
end