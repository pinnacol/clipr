module Clipr
  module Api
    module Struct
      # /************************************************************/
      # /* bitMapHashNode STRUCTURE:                                */
      # /************************************************************/
      # struct bitMapHashNode
      #   {
      #    struct bitMapHashNode *next;
      #    long count;
      #    int depth;
      #    unsigned int permanent : 1;
      #    unsigned int markedEphemeral : 1;
      #    unsigned int neededBitMap : 1;
      #    unsigned int bucket : 29;
      #    char *contents;
      #    unsigned short size;
      #   };
      #
      class BitMapHashNode < FFI::Struct
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32,
               :contents, :string,
               :size, :ushort
      end
    end
  end
end