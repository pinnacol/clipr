module Clipr
  module Api
    module Struct
      # ==== Definition
      #
      #   [symbol.h]
      #   struct integerHashNode
      #     {
      #      struct integerHashNode *next;
      #      long count;
      #      int depth;
      #      unsigned int permanent : 1;
      #      unsigned int markedEphemeral : 1;
      #      unsigned int neededInteger : 1;
      #      unsigned int bucket : 29;
      #      long long contents;
      #     };
      #
      class IntegerHashNode < FFI::Struct
        class << self
          def contents(obj)
            new(obj[:value])[:contents]
          end
          
          alias value contents
        end
        
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32,
               :contents, :long_long
      end
    end
  end
end
