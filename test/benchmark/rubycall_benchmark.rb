require File.join(File.dirname(__FILE__), '../test_helper')
require 'clips'
require 'benchmark'

class RubycallBenchmark < Test::Unit::TestCase
  acts_as_subset_test
  
  def test_rubycall_speed
    benchmark_test(20) do |x|
      n = 10
      block = lambda { }
      block_id = block.object_id.to_s
      env = Clips::Env.new
      
      x.report("#{n}k call") do
        (n * 1000).times { block.call }
      end
      
      x.report("#{n}k env.call") do
        (n * 1000).times { env.call("ruby-call", block_id) }
      end
      
      x.report("#{n}k EnvFunctionCall") do
        ptr = env.pointer
        obj = Clips::Api::DataObject.new
        api = Clips::Api::Environment
        
        (n * 1000).times { api::EnvFunctionCall(ptr, "ruby-call", block_id, obj) }
      end
    end
  end
end