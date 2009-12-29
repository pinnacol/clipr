require File.dirname(__FILE__) + "/../test_helper"
require "clipr/routers"

class RoutersTest < Test::Unit::TestCase
  Routers = Clipr::Routers
  
  class MockEnv
    attr_accessor :pointer
  end
  
  attr_reader :env, :routers
  
  def setup
    @env = MockEnv.new
    @routers = Routers.new(env)
  end
  
  #
  # AGET test
  #
  
  def test_AGET_raises_an_error_for_unknown_router
    err = assert_raises(RuntimeError) { routers['unknown'] }
    assert_equal "unknown router: \"unknown\"", err.message
  end
end