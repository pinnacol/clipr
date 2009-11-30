require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clips/api'

class ApiDataObjectTest < Test::Unit::TestCase
  DataObject = Clips::Api::DataObject
  
  def test_data_objects_can_be_created
    o = DataObject.new
    assert_equal DataObject, o.class
  end
end