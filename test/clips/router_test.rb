require File.dirname(__FILE__) + "/../test_helper"
require "clips/router"

class RouterTest < Test::Unit::TestCase
  Router = Clips::Router
  
  attr_reader :device, :router
  
  def setup
    @device = StringIO.new
    @router = Router.new
  end
  
  #
  # capture test
  #
  
  def test_capture_reassigns_device_for_duration_of_block
    router['dev'] = device
    
    was_in_block = false
    result = router.capture('dev') do |dev|
      was_in_block = true
      
      assert dev != device
      assert_equal dev, router['dev']
      
      :result
    end
    
    assert_equal true, was_in_block
    assert_equal :result, result
    assert_equal device, router['dev']
  end
  
  def test_capture_resets_dev_even_on_error
    router['dev'] = device
    err = assert_raises(RuntimeError) do
      router.capture('dev') do |dev|
        raise "error"
      end
    end
    
    assert_equal "error", err.message
    assert_equal device, router['dev']
  end
end