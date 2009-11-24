require File.dirname(__FILE__) + "/test_helper"
require "clips"

class ClipsTest < Test::Unit::TestCase
  
  def test_clips
    assert_equal true, Clips.kind_of?(Class)
  end
end