require File.join(File.dirname(__FILE__), '../test_helper')
require 'clipr'
require 'benchmark'

class RubycallBenchmark < Test::Unit::TestCase
  acts_as_subset_test
  
  def test_rubycall_speed
    benchmark_test(20) do |x|
      n = 10
      block = lambda { }
      block_id = block.object_id.to_s
      env = Clipr::Env.new
      
      x.report("#{n}k call") do
        (n * 1000).times { block.call }
      end
      
      x.report("#{n}k env.call") do
        (n * 1000).times { env.call("ruby-call", block_id) }
      end
      
      x.report("#{n}k EnvFunctionCall") do
        ptr = env.pointer
        obj = Clipr::Api::DataObject.new
        api = Clipr::Api::Environment
        
        (n * 1000).times { api::EnvFunctionCall(ptr, "ruby-call", block_id, obj) }
      end
    end
  end
  
  def test_assertion
    benchmark_test(20) do |x|
      n = 10
      env = Clipr::Env.new
      
      x.report("#{n}k overhead") do
        1.upto(n * 1000) {|i| "(fact #{i})" }
      end
      
      x.report("#{n}k assert") do
        1.upto(n * 1000) {|i| env.assert("(fact #{i})")}
      end
    end
  end
end