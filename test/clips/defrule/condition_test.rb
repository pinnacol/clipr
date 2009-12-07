require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clips'

class ConditionTest < Test::Unit::TestCase
  include BlockHelpers
  Condition = Clips::Defrule::Condition
  
  #
  # slot test
  #
  
  def test_slot_specifies_simple_condition
    cond = Condition.intern("sample") do
      slot "key", :value
    end
    
    assert_equal "(sample (key value))", cond.to_s
  end
  
  def test_slot_allows_symbol_keys
    cond = Condition.intern("sample") do
      slot :key, :value
    end
    
    assert_equal "(sample (key value))", cond.to_s
  end
  
  def test_slot_equal_combines_terms_using_or
    cond = Condition.intern("sample") do
      slot :key, equal(:a, :b, :c)
    end
    
    assert_equal "(sample (key a|b|c))", cond.to_s
  end
  
  def test_slot_not_equal_combines_terms_using_and
    cond = Condition.intern("sample") do
      slot :key, not_equal(:a, :b, :c)
    end
    
    assert_equal "(sample (key ~a&~b&~c))", cond.to_s
  end
  
  def test_slot_generates_cross_product_for_multiple_terms
    cond = Condition.intern("sample") do
      slot :key, equal(:a, :b), not_equal(:c, :d)
    end
    
    assert_equal "(sample (key a&~c&~d|b&~c&~d))", cond.to_s
  end
  
  def test_slot_handles_primitive_types_correctly
    cond = Condition.intern("sample") do
      slot :key, equal(:sym, "str", 1, 1.2)
    end
    
    assert_equal "(sample (key sym|\"str\"|1|1.2))", cond.to_s
  end
  
  def test_slot_handles_predicates_correctly
    p, oid = setup_block
    cond = Condition.intern("sample") do
      slot :key, &p
    end
    
    assert_equal "(sample (key ?v#{oid}&:(ruby-call #{oid} ?v#{oid})))", cond.to_s
  end
  
  def test_multiple_slots_may_be_specified_for_a_condition
    cond = Condition.intern("sample") do
      slot "a", :one
      slot "b", :two
      slot "c", :three
    end
    
    assert_equal "(sample (a one) (b two) (c three))", cond.to_s
  end
  
  def test_assignments_assign_variables
    cond = Condition.intern("sample") do
      assign :a, [:b, :alt]
    end
    
    assert_equal "(sample (a ?a) (b ?alt))", cond.to_s
  end
  
  def test_tests_are_formatted_to_receive_assignments
    t1, oid1 = setup_block
    t2, oid2 = setup_block
    
    cond = Condition.intern("sample") do
      assign :a, :b
      test(&t1)
      test(&t2)
    end
    
    assert_equal "(sample (a ?a) (b ?b)) (test (ruby-call #{oid1} ?a ?b)) (test (ruby-call #{oid2} ?a ?b))", cond.to_s
  end
  
  def test_tests_do_not_need_assignments
    t, oid = setup_block
    cond = Condition.intern("sample") do
      test(&t)
    end
    
    assert_equal "(sample) (test (ruby-call #{oid}))", cond.to_s
  end
  
  def test_conditions_are_assigned_to_variable
    cond = Condition.intern("sample", :variable => 'var')
    assert_equal "?var <- (sample)", cond.to_s
  end
end