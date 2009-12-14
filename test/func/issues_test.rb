require File.dirname(__FILE__) + "/../test_helper"
require "clips/env"

class IssuesTest < Test::Unit::TestCase
  acts_as_file_test
  
  Env = Clips::Env

  attr_reader :env
  
  def setup
    super
    @env = Env.new
  end
  
  # Platform: OSX 10.6.2 (Snow Leopard)
  # At: 1cb3abdc38643a7437bdfacef35356b0bf8efe79
  # Error:
  # <["(initial-fact)", "(key value)", "(key two)"]> expected but was
  # <["(initial-fact)", "(key two)"]>
  #
  # After clear/assert a fact will sometimes not be asserted correctly.  It
  # appears that the assertion fails the same way as when the fact already
  # exists in the knowledgebase (ie the pointer to the fact after
  # EnvAssertString has address 0).  Not an issue on 10.5.8.
  #
  def test_assert_clear_assert_a_fact
    assert_equal ["(initial-fact)"], env.facts.list
    env.assert("(key value)")
    env.assert("(key one)")
    assert_equal ["(initial-fact)", "(key value)", "(key one)"], env.facts.list
    
    env.clear
    assert_equal ["(initial-fact)"], env.facts.list
    env.assert("(key value)")
    env.assert("(key two)")
    assert_equal ["(initial-fact)", "(key value)", "(key two)"], env.facts.list
  end
end