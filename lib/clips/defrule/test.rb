module Clips
  class Defrule
    class Test < Callback
      def call(env, data_objects)
        data_objects.collect! {|obj| env.cast(obj) }
        callback.call(*data_objects)
      end
      
      def to_s
        "(test #{super})"
      end
    end
  end
end