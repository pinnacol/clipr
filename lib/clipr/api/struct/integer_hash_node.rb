module Clipr
  module Api
    module Struct
      # /************************************************************/
      # /* integerHashNode STRUCTURE:                               */
      # /************************************************************/
      # struct integerHashNode
      #   {
      #    struct integerHashNode *next;
      #    long count;
      #    int depth;
      #    unsigned int permanent : 1;
      #    unsigned int markedEphemeral : 1;
      #    unsigned int neededInteger : 1;
      #    unsigned int bucket : 29;
      #    long long contents;
      #   };
      #
      class IntegerHashNode < FFI::Struct
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32,
               :contents, :long_long
      end
    end
  end
end
