require File.dirname(__FILE__) + "/test_helper"
require "clips"

class ClipsTest < Test::Unit::TestCase
  acts_as_file_test
  include Clips::Api
  
  #
  # Save test
  #
  
  def test_clips_save_creates_specified_file
    path = method_root.prepare(:tmp, 'file.clip')
    assert !File.exists?(path)
    
    Environment.InitializeEnvironment
    Environment.Save(path)
    
    assert File.exists?(path)
  end
end