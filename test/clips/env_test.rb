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
  # initialize test
  #
  
  def test_initialize_sets_up_default_router
    routers = env.routers
    assert routers.list.include?('default')
    assert routers['default'].kind_of?(Clips::Router)
  end
  
  #
  # router test
  #
  
  def test_router_returns_the_DEFAULT_ROUTER_router
    assert_equal env.routers[Env::DEFAULT_ROUTER], env.router
  end
  
  #
  # build test
  #
  
  def test_build_returns_self
    template = %q{
    (deftemplate sample 
      "desc" 
      (slot key 
        (type SYMBOL) 
        (default value)))}
        
    assert_equal env, env.build(template)
  end
  
  def test_build_raises_error_for_invalid_constructs
    template = %q{
    (deftemplate sample 
      "desc" 
      (slot key 
        (type STRING) 
        (default value)))}
    
    err = assert_raises(RuntimeError) { env.build(template) }
    assert_equal %q{
[CSTRNCHK1] An expression found in the default attribute
does not match the allowed types for slot key.

ERROR:
(deftemplate MAIN::sample "desc"
   (slot key (type STRING) (default value))
}, err.message
  end

  def test_build_raises_error_for_unbuildable_constructs
    err = assert_raises(RuntimeError) { env.build("(assert (quack))") }
    assert_equal "could not build: (assert (quack))", err.message
  end
  
  #
  # classes test
  #
  
  def test_facts_classes_returns_classes_string
    assert_equal "MAIN:\n   FLOAT\n   INTEGER\n   SYMBOL\n   STRING\n   MULTIFIELD\n   EXTERNAL-ADDRESS\n   FACT-ADDRESS\n   INSTANCE-ADDRESS\n   INSTANCE-NAME\n   OBJECT\n   PRIMITIVE\n   NUMBER\n   LEXEME\n   ADDRESS\n   INSTANCE\n   USER\n   INITIAL-OBJECT\nFor a total of 17 defclasses.\n", env.classes
  end
  
  #
  # facts test
  #
  
  def test_facts_returns_facts_string
    assert_equal "f-0     (initial-fact)\nFor a total of 1 fact.\n", env.facts
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