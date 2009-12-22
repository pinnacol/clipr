module Clips
  class Callback
    class << self
      def intern(&block)
        block ? new(block) : nil
      end
    end
    
    attr_reader :callback
    
    def initialize(callback)
      @callback = callback
    end
    
    def call(env, data_objects)
      data_objects.collect! {|obj| env.cast(obj) }
      callback.call(*data_objects)
    end
  end
end