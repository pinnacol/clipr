require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clipr'

class SlotTest < Test::Unit::TestCase
  include BlockHelpers
  Deftemplate = Clipr::Deftemplate
  Slot = Clipr::Deftemplate::Slot
  
  def test_slot_formats_simple_slot
    slot = Slot.new("name")
    assert_equal "(slot name)", slot.to_s
  end
  
  def test_slot_formats_slot_with_primitive_default
    slot = Slot.new("sym", :sym)
    assert_equal "(slot sym (default sym))", slot.to_s
    
    slot = Slot.new("str", "str")
    assert_equal "(slot str (default \"str\"))", slot.to_s
    
    slot = Slot.new("int", 1)
    assert_equal "(slot int (default 1))", slot.to_s
    
    slot = Slot.new("float", 1.2)
    assert_equal "(slot float (default 1.2))", slot.to_s
  end
  
  def test_slot_provides_no_default_for_OPTIONAL_default
    slot = Slot.new("name", Deftemplate::OPTIONAL)
    assert_equal "(slot name)", slot.to_s
  end
  
  def test_slot_provides_none_for_NONE_default
    slot = Slot.new("name", Deftemplate::NONE)
    assert_equal "(slot name (default ?NONE))", slot.to_s
  end
  
  def test_slot_provides_derive_for_DERIVE_default
    slot = Slot.new("name", Deftemplate::DERIVE)
    assert_equal "(slot name (default ?DERIVE))", slot.to_s
  end
  
  def test_slot_raises_error_for_formatting_non_primitive_default
    obj = Object.new
    slot = Slot.new("obj", obj)
    err = assert_raises(RuntimeError) { slot.to_s }
    assert_equal "non-primitive default values are not supported yet: #{obj.inspect}", err.message
  end
  
  def test_slot_uses_dynamic_default_if_specified
    slot = Slot.new("name", :"(gensym*)", :dynamic_default => true)
    assert_equal "(slot name (dynamic-default (gensym*)))", slot.to_s
  end
  
  def test_slot_uses_multislot_if_specified
    slot = Slot.new("name", nil, :multislot => true)
    assert_equal "(multislot name)", slot.to_s
  end
  
  def test_slot_formats_type_constraints_if_specified
    slot = Slot.new("name", nil, :types => [:SYMBOL, :STRING])
    assert_equal "(slot name (type SYMBOL STRING))", slot.to_s
  end
  
  def test_slot_formats_allows_if_specified
    slot = Slot.new("name", nil, :allows => {:values => [:a, :b]})
    assert_equal "(slot name (allowed-values a b))", slot.to_s
  end
end
