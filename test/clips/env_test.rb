require File.dirname(__FILE__) + "/../test_helper"
require "clips/env"

class ClipsEnvTest < Test::Unit::TestCase
  acts_as_file_test
  Env = Clips::Env
  DataObject = Clips::Api::DataObject
  ApiError = Clips::ApiError
  
  attr_reader :env
  
  def setup
    super
    @env = Env.new
  end
  
  # def teardown
  #   env.close
  # end
  
  #
  # Env.open test
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
  # run test
  #
  
  def test_run_with_rubycall
    was_in_block = false
    block = lambda {|e, args| was_in_block = true }
    assert_equal false, was_in_block
    
    env.build  "(defrule sound-is-quack (sound quack) => (ruby-call #{block.object_id}))"
    env.assert "(sound honk)"
    
    assert_equal 0, env.run
    assert_equal false, was_in_block
    
    env.assert("(sound quack)")
    assert_equal 1, env.run
    assert_equal true, was_in_block
  end
  
  def test_run_with_simple_rule
    env.template :simple do
      slot :key
    end
    
    env.rule do
      lhs do
        match :simple, :key => :value
      end
      
      rhs do
        callback do |env|
          env.assert "(was in block)"
        end
      end
    end
    
    env.run
    assert_equal ["(initial-fact)"], env.facts.list
    
    env.assert "(simple (key alt))"
    env.run
    assert_equal ["(initial-fact)", "(simple (key alt))"], env.facts.list
    
    env.assert "(simple (key value))"
    env.run
    assert_equal ["(initial-fact)", "(simple (key alt))", "(simple (key value))", "(was in block)"], env.facts.list
  end
  
  #
  # call test
  #
  
  def test_call_calls_the_function_and_returns_data_object
    obj = env.call(">", "1 2")
    assert_equal DataObject, obj.class
    assert_equal false, obj.value
    
    obj = env.call(">", "2 1")
    assert_equal DataObject, obj.class
    assert_equal true, obj.value
  end
  
  def test_call_raises_error_for_unknown_functions
    err = assert_raises(ApiError) { env.call("unknown") }
    assert_equal "[EVALUATN2] No function, generic function or deffunction of name unknown exists for external call.\n", err.message
  end
  
  def test_rubycall_calls_block_with_env
    was_in_block = false
    block = lambda do |e, args|
      assert_equal e, env
      was_in_block = true
    end
    
    assert_equal false, was_in_block
    
    env.call("ruby-call", block.object_id.to_s)
    assert_equal true, was_in_block
  end
  
  def test_rubycall_returns_true_if_block_returns_truthy
    block = lambda {|e, args| true }
    assert_equal true, env.call("ruby-call", block.object_id.to_s).value
    
    block = lambda {|e, args| 1 }
    assert_equal true, env.call("ruby-call", block.object_id.to_s).value
    
    block = lambda {|e, args| "str" }
    assert_equal true, env.call("ruby-call", block.object_id.to_s).value
    
    # falsy
    block = lambda {|e, args| false }
    assert_equal false, env.call("ruby-call", block.object_id.to_s).value
    
    block = lambda {|e, args| nil }
    assert_equal false, env.call("ruby-call", block.object_id.to_s).value
  end

  def test_rubycall_raises_error_when_block_is_missing
    err = assert_raises(ArgumentError) { env.call("ruby-call") }
    assert_equal "no block id given", err.message
  end

  def test_rubycall_raises_error_when_block_does_not_exist
    err = assert_raises(RangeError) { ObjectSpace._id2ref(1234) }
    assert_equal "0x4d2 is not id value", err.message
    
    err = assert_raises(RangeError) { env.call("ruby-call", "1234") }
    assert_equal "0x4d2 is not id value", err.message
  end
  
  def test_rubycall_passes_back_pattern_addresses
    was_in_block = false
    block = lambda do |e, args|
      assert_equal 1, args.length
      
      obj = args[0]
      assert_equal Clips::Api::DataObject, obj.class
      assert_equal :quack, e.cast(obj)[:sound]
      
      was_in_block = true
    end
    
    env.build  "(deftemplate animal (slot sound))"
    env.build  "(defrule sound-is-quack ?fact <- (animal (sound quack)) => (ruby-call #{block.object_id} ?fact)) "
    env.assert "(animal (sound quack))"
    
    assert_equal false, was_in_block
    assert_equal 1, env.run
    assert_equal true, was_in_block
  end
  
  #
  # build test
  #
  
  def test_build_builds_construct_and_returns_self
    construct = %q{
    (deftemplate sample 
      "desc" 
      (slot key 
        (type SYMBOL) 
        (default value)))}
    
    assert_equal env, env.build(construct)
  end
  
  def test_build_raises_error_for_invalid_constructs
    construct = %q{
    (deftemplate sample 
      "desc" 
      (slot key 
        (type STRING) 
        (default value)))}
    
    err = assert_raises(ApiError) { env.build(construct) }
    assert_equal %q{
[CSTRNCHK1] An expression found in the default attribute
does not match the allowed types for slot key.

ERROR:
(deftemplate MAIN::sample "desc"
   (slot key (type STRING) (default value))
}, err.message
  end

  def test_build_raises_error_for_unbuildable_constructs
    err = assert_raises(ApiError) { env.build "(assert (quack))" }
    assert_equal "could not build: (assert (quack))", err.message
  end
  
  #
  # assert test
  #
  
  def test_assert_asserts_fact_string
    env.assert("(goodnight moon)")
    assert_equal ["(initial-fact)", "(goodnight moon)"], env.facts.list
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