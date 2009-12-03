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
  # run test
  #
  
  def test_run_with_rubycall
    was_in_block = false
    block = lambda { was_in_block = true }
    assert_equal false, was_in_block
    
    Clips::Api::Environment.EnvBuild(env.pointer, "(defrule sound-is-quack (sound quack) => (ruby-call #{block.object_id}))")
    
    env.assert_string("(sound honk)")
    assert_equal 0, env.run
    assert_equal false, was_in_block
    
    env.assert_string("(sound quack)")
    assert_equal 1, env.run
    assert_equal true, was_in_block
  end
  
  #
  # call test
  #
  
  def test_call_calls_the_function_and_returns_result
    result = env.call(">", "1 2")
    assert_equal false, result
    
    result = env.call(">", "2 1")
    assert_equal true, result
  end
  
  def test_call_raises_error_for_unknown_functions
    err = assert_raises(RuntimeError) { env.call("unknown") }
    assert_equal "[EVALUATN2] No function, generic function or deffunction of name unknown exists for external call.\n", err.message
  end
  
  def test_rubycall_calls_block
    was_in_block = false
    block = lambda { was_in_block = true }
    assert_equal false, was_in_block
    
    env.call("ruby-call", block.object_id.to_s)
    assert_equal true, was_in_block
  end
  
  def test_rubycall_returns_true_if_block_returns_truthy
    block = lambda { true }
    assert_equal true, env.call("ruby-call", block.object_id.to_s)
    
    block = lambda { 1 }
    assert_equal true, env.call("ruby-call", block.object_id.to_s)
    
    block = lambda { "str" }
    assert_equal true, env.call("ruby-call", block.object_id.to_s)
    
    # falsy
    block = lambda { false }
    assert_equal false, env.call("ruby-call", block.object_id.to_s)
    
    block = lambda { nil }
    assert_equal false, env.call("ruby-call", block.object_id.to_s)
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
  
  class RubyCallFact < Clips::Fact
    slot :key, 'value'
    
    def initialize(attrs={})
      @attrs = attrs
    end
    
    def each_pair
      @attrs.each_pair {|k,v| yield(k,v) }
    end
  end
  
  def test_rubycall_passes_back_pattern_addresses
    block_args = nil
    block = lambda {|*args| block_args = args }
    
    Clips::Api::Environment.EnvBuild(env.pointer, "(deftemplate animal (slot sound))")
    Clips::Api::Environment.EnvBuild(env.pointer, "(defrule sound-is-quack ?fact <- (animal (sound quack)) => (ruby-call #{block.object_id} ?fact)) ")
    env.assert_string("(animal (sound quack))")
    
    assert_equal nil, block_args
    assert_equal 1, env.run
    assert_equal 1, block_args.length
    
    ptr = block_args[0]
    assert_equal Clips::Api::DataObject, ptr.class

    obj = Clips::Api::DataObject.new 
    assert_equal 1, Clips::Api::Fact::EnvGetFactSlot(env.pointer, ptr[:value], "sound", obj)
    assert_equal "quack", obj.value
  end
  
  #
  # build test
  #
  
  class BuildClass
    include Clips::Construct
    
    attr_accessor :content
    
    def initialize(content)
      reset
      @content = content
    end
  end
  
  def test_build_sets_construct_and_returns_self
    template = %q{
    (deftemplate sample 
      "desc" 
      (slot key 
        (type SYMBOL) 
        (default value)))}
    
    construct = BuildClass.new(template)
    assert_equal env, env.build(construct)
    assert_equal({construct.sha => construct}, env.constructs)
  end
  
  def test_build_raises_error_for_invalid_constructs
    template = %q{
    (deftemplate sample 
      "desc" 
      (slot key 
        (type STRING) 
        (default value)))}
    
    err = assert_raises(RuntimeError) { env.build(BuildClass.new(template)) }
    assert_equal %q{
[CSTRNCHK1] An expression found in the default attribute
does not match the allowed types for slot key.

ERROR:
(deftemplate MAIN::sample "desc"
   (slot key (type STRING) (default value))
}, err.message
  end

  def test_build_raises_error_for_unbuildable_constructs
    template = "(assert (quack))"
    err = assert_raises(RuntimeError) { env.build(BuildClass.new(template)) }
    assert_equal "could not build: (assert (quack))", err.message
  end
  
  #
  # assert_string test
  #
  
  def test_assert_string_asserts_fact_string
    env.assert_string("(goodnight moon)")
    assert_equal "f-0     (initial-fact)\nf-1     (goodnight moon)\nFor a total of 2 facts.\n", env.facts
  end
  
  #
  # assert test
  #
  
  class AssertFact < Clips::Fact
    slot :key, 'value'
    
    def initialize(attrs={})
      @attrs = attrs
    end
    
    def each_pair
      @attrs.each_pair {|k,v| yield(k,v) }
    end
  end
  
  def test_assert_asserts_fact
    fact = AssertFact.new
    env.assert(fact)
    assert_equal "f-0     (initial-fact)\nf-1     (ClipsEnvTest_AssertFact (key value))\nFor a total of 2 facts.\n", env.facts
  end
  
  def test_assert_asserts_fact_with_non_default_value
    fact = AssertFact.new(:key => 'alt')
    env.assert(fact)
    assert_equal "f-0     (initial-fact)\nf-1     (ClipsEnvTest_AssertFact (key alt))\nFor a total of 2 facts.\n", env.facts
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