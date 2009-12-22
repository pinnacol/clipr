module Clipr
  class Defrule
    class Action < Callback
      def call(env, data_objects)
        data_objects.collect! {|obj| env.cast(obj) }
        callback.call(env, *data_objects)
      end
    end
  end
end