require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clips/api'

class ApiDataObjectTest < Test::Unit::TestCase
  include Clips::Api
  
  #
  # intern test
  #
  
  def test_intern_creates_new_data_object_with_types_and_values
    value = FFI::MemoryPointer.new :double
    
    o = DataObject.intern(:type => FLOAT, :value => value)
    assert_equal FLOAT, o[:type]
    assert_equal value, o[:value]
  end
  
  #
  # initialize test
  #
  
  def test_data_objects_can_be_created
    o = DataObject.new
    assert_equal DataObject, o.class
  end
end