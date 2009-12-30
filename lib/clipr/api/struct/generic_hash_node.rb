module Clipr
  module Api
    module Struct
      # /************************************************************/
      # /* genericHashNode STRUCTURE:                               */
      # /************************************************************/
      # struct genericHashNode
      #   {
      #    struct genericHashNode *next;
      #    long count;
      #    int depth;
      #    unsigned int permanent : 1;
      #    unsigned int markedEphemeral : 1;
      #    unsigned int needed : 1;
      #    unsigned int bucket : 29;
      #   };
      class GenericHashNode < FFI::Struct
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32
      end
    end
  end
end