require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clips'

class ConditionsTest < Test::Unit::TestCase
  include BlockHelpers
  Conditions = Clips::Defrule::Conditions
  
  def test_add_adds_a_literal_condition
    conds = Conditions.intern do
      add "(sample (key one))"
      add "(sample (key two))"
    end
    
    assert_equal "(sample (key one)) (sample (key two))", conds.to_s
  end
  
  def test_match_specifies_conditions_as_hash
    conds = Conditions.intern do
      match "sample", :key => :value
    end
    
    assert_equal "(sample (key value))", conds.to_s
  end
  
  def test_match_allows_array_conditions
    conds = Conditions.intern do
      match "sample", [[:key, :value]]
    end
    
    assert_equal "(sample (key value))", conds.to_s
  end
  
  def test_match_primitive_and_ruby_types
    obj = Object.new
    oid = obj.object_id
    
    conds = Conditions.intern do
      match "sample", [[:sym, :value], [:str, "value"], [:int, 1], [:float, 1.2], [:obj, obj]]
    end
    
    assert_equal "(sample (sym value) (str \"value\") (int 1) (float 1.2) (obj ?v#{oid}&:(ruby-equal #{oid} ?v#{oid})))", conds.to_s
  end
  
  def test_match_sets_block_as_test
    block = lambda {}
    conds = Conditions.new
    cond = conds.match "sample", :a, :b, &block
    test = cond.tests[0]
    
    assert_equal block, test.callback
    assert_equal "(sample (a ?a) (b ?b)) (test (ruby-call #{test.object_id} ?a ?b))", conds.to_s
  end
  
  def test_condition_interns_condition
    conds = Conditions.intern do
      condition "sample" do
        slot :key, :value
      end
    end
    
    assert_equal "(sample (key value))", conds.to_s
  end
  
  def test_assign_sets_condition_variable
    conds = Conditions.intern do
      assign :var, "sample", :key => :value
    end
    
    assert_equal "?var <- (sample (key value))", conds.to_s
  end
  
  def test_any_sets_or_condition
    conds = Conditions.intern do
      any do
        match "a", :key => :one
        match "b", :key => :two
      end
    end
    
    assert_equal "(or (a (key one)) (b (key two)))", conds.to_s
  end
  
  def test_all_sets_and_condition
    conds = Conditions.intern do
      all do
        match "a", :key => :one
        match "b", :key => :two
      end
    end
    
    assert_equal "(and (a (key one)) (b (key two)))", conds.to_s
  end

  def test_exists_sets_exists_condition
    conds = Conditions.intern do
      exists do
        match "a", :key => :one
        match "b", :key => :two
      end
    end
    
    assert_equal "(exists (a (key one)) (b (key two)))", conds.to_s
  end
  
  def test_any_and_all_will_nest
    conds = Conditions.intern do
      any do
        all do
          match "a", :k => :one
          match "b", :k => :two
        end
        match "c", :k => :three
      end
      match "d", :k => :four
    end
    
    assert_equal "(or (and (a (k one)) (b (k two))) (c (k three))) (d (k four))", conds.to_s
  end
  
  def test_not_match_negates_match
    conds = Conditions.intern do
      not_match "sample", :key => :value
    end
    
    assert_equal "(not (sample (key value)))", conds.to_s
  end
  
  def test_not_any_negates_any
    conds = Conditions.intern do
      not_any do
        match "sample", :key => :value
      end
    end
    
    assert_equal "(not (or (sample (key value))))", conds.to_s
  end
  
  def test_not_all_negates_all
    conds = Conditions.intern do
      not_all do
        match "sample", :key => :value
      end
    end
    
    assert_equal "(not (and (sample (key value))))", conds.to_s
  end
  
  def test_not_exists_negates_exists
    conds = Conditions.intern do
      not_exists do
        match "a", :key => :one
        match "b", :key => :two
      end
    end
    
    assert_equal "(not (exists (a (key one)) (b (key two))))", conds.to_s
  end
  
  def test_check_receives_variables_from_all_nested_assignments_in_order
    t1, oid1 = setup_block
    t2, oid2 = setup_block
    conds = Conditions.intern do
      assign :a, :one
      
      not_all do
        assign :b, :two
        check(&t1)
      end
      
      assign :c, :three
      check(&t2)
    end
    
    assert_equal "?a <- (one) (not (and ?b <- (two) (test (ruby-call #{oid1} ?b)))) ?c <- (three) (test (ruby-call #{oid2} ?a ?b ?c))", conds.to_s
  end
  
  def test_check_only_receives_variables_defined_up_to_the_point_of_check
    t, oid = setup_block
    conds = Conditions.intern do
      assign :a, :one
      check(&t)
      assign :b, :two
    end
    
    assert_equal "?a <- (one) (test (ruby-call #{oid} ?a)) ?b <- (two)", conds.to_s
  end
  
  #
  # dup test
  #
  
  def test_duplicates_do_not_add_conditions_to_one_another
    a = Conditions.new
    a.match "a", :key => :a
    b = a.dup
    
    assert_equal "(a (key a))", a.to_s
    assert_equal "(a (key a))", b.to_s
    
    b.match "b", :key => :b
    a.match "c", :key => :c
    
    assert_equal "(a (key a)) (c (key c))", a.to_s
    assert_equal "(a (key a)) (b (key b))", b.to_s
  end
end
