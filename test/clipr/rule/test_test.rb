require "#{File.dirname(__FILE__)}/../../test_helper.rb"
require 'clipr'

class TestTest < Test::Unit::TestCase
  Test = Clipr::Rule::Test
  
  attr_reader :block
  
  def setup
    @block = lambda {}
  end
  
  #
  # to_s test
  #
  
  def test_to_s_formats_test_to_call_back_to_callback
    t = Test.new(block, [])
    
    assert_equal block, t.callback
    assert_equal "(test (ruby-call #{t.object_id}))", t.to_s
  end
  
  def test_to_s_adds_vars
    t = Test.new(block, [:a, :b])
    assert_equal "(test (ruby-call #{t.object_id} ?a ?b))", t.to_s
  end
end