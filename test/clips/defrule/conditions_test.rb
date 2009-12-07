require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clips/env'

class ConditionsTest < Test::Unit::TestCase
  Conditions = Clips::Defrule::Conditions

  def setup_block
    block = lambda {}
    oid = block.object_id
    [block, oid]
  end
  
  #
  # match test
  #
  
  def test_match_specifies_conditions_as_hash
    conds = Conditions.intern do
      match "sample", :key => :value
    end
    
    assert_equal "(sample (key value))", conds.to_s
  end
  
  def test_match_specifies_allows_array_conditions
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
end
