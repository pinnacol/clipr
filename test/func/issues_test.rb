require File.dirname(__FILE__) + "/../test_helper"
require "clipr/env"

class IssuesTest < Test::Unit::TestCase
  acts_as_file_test
  acts_as_shell_test
  
  Env = Clipr::Env

  attr_reader :env
  
  def setup
    super
    @env = Env.new
  end
  
  # suppress some logging...
  def quiet?
    verbose? ? false : true
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
  
  def test_assert_clear_assert_a_fact_in_c
    sh_test %Q{
% "#{method_root.root}/main.test"
f-0     (initial-fact)
For a total of 1 fact.
f-0     (initial-fact)
f-1     (key value)
f-2     (key one)
For a total of 3 facts.
f-0     (initial-fact)
For a total of 1 fact.
f-0     (initial-fact)
f-1     (key value)
f-2     (key two)
For a total of 3 facts.
}
  end
end