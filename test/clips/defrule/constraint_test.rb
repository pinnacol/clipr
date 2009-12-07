require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clips/env'

class ConstraintTest < Test::Unit::TestCase
  Constraint = Clips::Defrule::Constraint
  
  #
  # to_s test
  #
  
  def test_to_s_formats_term
    c = Constraint.new("key", ["value"])
    assert_equal "(key value)", c.to_s
  end
  
  def test_to_s_formats_array_terms_using_or
    c = Constraint.new("key", [["a", "b", "c"]])
    assert_equal "(key a|b|c)", c.to_s
  end
  
  def test_to_s_formats_multiple_terms_using_and
    c = Constraint.new("key", [["a"], "b", ["c"]])
    assert_equal "(key a&b&c)", c.to_s
  end
  
  def test_to_s_constructs_cross_product_for_multiple_terms
    c = Constraint.new("key", [["a", "b"], "c"])
    assert_equal "(key a&c|b&c)", c.to_s
    
    c = Constraint.new("key", [["a", "b"], ["c", "d"]])
    assert_equal "(key a&c|a&d|b&c|b&d)", c.to_s
  end
  
  def test_to_s_adds_predicate_if_specified
    p = lambda {}
    oid = p.object_id
    
    c = Constraint.new("key", ["a"], &p)
    assert_equal "(key ?v#{oid}&a&:(ruby-call #{oid} ?v#{oid}))", c.to_s
  end
  
  def test_to_s_adds_predicate_to_each_cross_product
    p = lambda {}
    oid = p.object_id
    
    c = Constraint.new("key", [["a", "b"], "c"], &p)
    assert_equal "(key ?v#{oid}&a&c&:(ruby-call #{oid} ?v#{oid})|b&c&:(ruby-call #{oid} ?v#{oid}))", c.to_s
  end
end