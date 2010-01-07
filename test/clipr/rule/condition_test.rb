require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clipr'

class ConditionTest < Test::Unit::TestCase
  Condition = Clipr::Rule::Condition
  Test = Clipr::Rule::Test
  
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
    block = lambda {}
    cond = Condition.new("sample")
    constraint = cond.slot(:key, &block)
    assert_equal block, constraint.predicate
    
    oid = constraint.object_id
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
  
  def test_test_adds_test
    t1 = lambda {}
    t2 = lambda {}
    
    cond = Condition.intern("sample")
    cond.assign :a, :b
    test1 = cond.test(:a, &t1)
    test2 = cond.test(:b, :a, &t2)
    
    assert_equal Test, test1.class
    assert_equal t1, test1.callback
    assert_equal [:a], test1.variables
    
    assert_equal Test, test2.class
    assert_equal t2, test2.callback
    assert_equal [:b, :a], test2.variables
    
    assert_equal "(sample (a ?a) (b ?b)) #{test1} #{test2}", cond.to_s
  end
  
  def test_tests_do_not_need_assignments
    cond = Condition.intern("sample")
    test = cond.test {}
    
    assert_equal [], test.variables
    assert_equal "(sample) #{test}", cond.to_s
  end
  
  def test_conditions_are_assigned_to_variable
    cond = Condition.intern("sample", :variable => 'var')
    assert_equal "?var <- (sample)", cond.to_s
  end
end