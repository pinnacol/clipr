require File.join(File.dirname(__FILE__), '../test_helper')
require 'clips'
require 'benchmark'

class RubycallBenchmark < Test::Unit::TestCase
  acts_as_subset_test
  
  def test_rubycall_speed
    benchmark_test do |x|
      n = 10
      block = lambda { }
      block_id = block.object_id.to_s
      env = Clips::Env.new
      
      x.report("#{n}k call") do
        (n * 1000).times { block.call }
      end
      
      x.report("#{n}k rubycall") do
        (n * 1000).times { env.call("ruby-call", block_id) }
      end
    end
  end
end