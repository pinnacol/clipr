module Clips
  class Callback
    attr_reader :block
    
    def initialize(&block)
      @block = block
    end
    
    def call(env, data_objects)
      data_objects.collect! {|obj| env.cast(obj) }
      block.call(*data_objects)
    end
  end
end