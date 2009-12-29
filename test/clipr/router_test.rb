require File.dirname(__FILE__) + "/../test_helper"
require "clipr/router"

class RouterTest < Test::Unit::TestCase
  Router = Clipr::Router
  
  attr_reader :device, :router
  
  def setup
    @device = StringIO.new
    @router = Router.new
  end
  
  #
  # device test
  #
  
  def test_device_raises_an_error_for_unknown_device
    err = assert_raises(RuntimeError) { router.device('unknown') }
    assert_equal "unknown device: \"unknown\"", err.message
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
  
  #
  # extend test
  #
  
  module ExtendMod
  end
  
  def test_extend_raises_error
    err = assert_raises(RuntimeError) { router.extend(ExtendMod) }
    assert_equal "router may not be extended", err.message
  end
end