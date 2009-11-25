require File.dirname(__FILE__) + "/../test_helper"
require "clips/env"

class ClipsEnvTest < Test::Unit::TestCase
  acts_as_file_test
  Env = Clips::Env
  
  attr_reader :env
  
  def setup
    super
    @env = Env.new
  end
  
  #
  # class.open test
  #
  
  def test_open_without_block_returns_open_env
    result = Env.open
    
    assert result.kind_of?(Env)
    assert !result.closed?
  end
  
  def test_open_closes_env_after_block
    was_in_block = false
    result = Env.open do |env|
      was_in_block = true
      assert !env.closed?
      env
    end
    
    assert was_in_block
    assert result.kind_of?(Env)
    assert result.closed?
  end
  
  #
  # close test
  #
  
  def test_close_unassigns_pointer
    env.pointer
    
    assert_equal true, env.close
    
    err = assert_raises(RuntimeError) { env.pointer }
    assert_equal "closed env", err.message
  end
  
  def test_close_returns_false_once_closed
    assert_equal true, env.close
    assert_equal false, env.close
    assert_equal false, env.close
  end
  
  #
  # closed? test
  #
  
  def test_closed_is_true_once_closed
    assert_equal false, env.closed?
    env.close
    assert_equal true, env.closed?
  end
  
  #
  # save test
  #
  
  def test_save_facts
    path = method_root.prepare(:tmp, 'file.clip')
    assert !File.exists?(path)
    
    env.save(path)
    
    assert_equal "(initial-fact)\n", File.read(path)
  end
end