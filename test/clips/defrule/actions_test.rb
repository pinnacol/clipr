require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clipr'

class ActionsTest < Test::Unit::TestCase
  include BlockHelpers
  Actions = Clipr::Defrule::Actions
  
  def test_add_adds_string_action
    actions = Actions.intern do
      add "(> 1 2)"
    end
    
    assert_equal "(> 1 2)", actions.to_s
  end
  
  def test_register_registers_callable_object_as_action
    block = lambda {}
    actions = Actions.new
    action = actions.register(block, :a, :b)
    
    assert_equal block, action.callback
    assert_equal [:a, :b], action.variables
  end
  
  def test_callback_registers_block_as_action
    block = lambda {}
    actions = Actions.new
    action = actions.callback(:a, :b, &block)
    
    assert_equal block, action.callback
    assert_equal [:a, :b], action.variables
  end
  
  #
  # dup test
  #
  
  def test_duplicates_do_not_add_actions_to_one_another
    t1, oid1 = setup_block
    t2, oid2 = setup_block
    t3, oid3 = setup_block
    
    a = Actions.new
    action1 = a.callback {}
    b = a.dup
    
    assert_equal "#{action1}", a.to_s
    assert_equal "#{action1}", b.to_s
    
    action2 = b.callback {}
    action3 = a.callback {}
    
    assert_equal "#{action1} #{action3}", a.to_s
    assert_equal "#{action1} #{action2}", b.to_s
  end
end