require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clips'

class ActionsTest < Test::Unit::TestCase
  include BlockHelpers
  Actions = Clips::Defrule::Actions
  
  def test_add_adds_string_action
    actions = Actions.intern do
      add "(> 1 2)"
    end
    
    assert_equal "(> 1 2)", actions.to_s
  end
  
  def test_register_registers_callable_object
    block, oid = setup_block
    
    actions = Actions.intern do
      register(block)
    end
    
    assert_equal "(ruby-call #{oid})", actions.to_s
  end
  
  def test_call_registers_block
    block, oid = setup_block
    
    actions = Actions.intern do
      call(&block)
    end
    
    assert_equal "(ruby-call #{oid})", actions.to_s
  end
  
  def test_actions_are_formatted_with_vars
    t1, oid1 = setup_block
    t2, oid2 = setup_block
    
    actions = Actions.intern do
      call(&t1)
      call(&t2)
    end
    
    actions.vars = " ?a ?b ?c"
    assert_equal "(ruby-call #{oid1} ?a ?b ?c) (ruby-call #{oid2} ?a ?b ?c)", actions.to_s
    
    actions.vars = " ?x ?y"
    assert_equal "(ruby-call #{oid1} ?x ?y) (ruby-call #{oid2} ?x ?y)", actions.to_s
  end
  
  #
  # dup test
  #
  
  def test_duplicates_do_not_add_actions_to_one_another
    t1, oid1 = setup_block
    t2, oid2 = setup_block
    t3, oid3 = setup_block
    
    a = Actions.new
    a.call(&t1)
    b = a.dup
    
    assert_equal "(ruby-call #{oid1})", a.to_s
    assert_equal "(ruby-call #{oid1})", b.to_s
    
    b.call(&t2)
    a.call(&t3)
    
    assert_equal "(ruby-call #{oid1}) (ruby-call #{oid3})", a.to_s
    assert_equal "(ruby-call #{oid1}) (ruby-call #{oid2})", b.to_s
  end
end