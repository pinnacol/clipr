module Clipr
  module Api
    module Struct
      # /************************************************************/
      # /* floatHashNode STRUCTURE:                                 */
      # /************************************************************/
      # struct floatHashNode
      #   {
      #    struct floatHashNode *next;
      #    long count;
      #    int depth;
      #    unsigned int permanent : 1;
      #    unsigned int markedEphemeral : 1;
      #    unsigned int neededFloat : 1;
      #    unsigned int bucket : 29;
      #    double contents;
      #   };
      #
      class FloatHashNode < FFI::Struct
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32,
               :contents, :double
      end
    end
  end
end
