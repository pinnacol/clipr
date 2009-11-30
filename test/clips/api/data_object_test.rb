require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clips/api'

class ApiDataObjectTest < Test::Unit::TestCase
  DataObject = Clips::Api::DataObject
  
  def test_data_objects_can_be_created
    o = DataObject.new
    assert_equal DataObject, o.class
  end
  
  def test_data_objects_can_be_created_with_types_and_values
    type = DataObject::FLOAT
    value = FFI::MemoryPointer.new :double
    
    o = DataObject.new(:type => type, :value => value)
    assert_equal DataObject::FLOAT, o[:type]
    assert_equal value, o[:value]
  end
end