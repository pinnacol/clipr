module Clipr
  module Api
    module Struct
      # /************************************************************/
      # /* symbolHashNode STRUCTURE:                                */
      # /************************************************************/
      # struct symbolHashNode
      #   {
      #    struct symbolHashNode *next;
      #    long count;
      #    int depth;
      #    unsigned int permanent : 1;
      #    unsigned int markedEphemeral : 1;
      #    unsigned int neededSymbol : 1;
      #    unsigned int bucket : 29;
      #    char *contents;
      #   };
      #
      class SymbolHashNode < FFI::Struct
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32,
               :contents, :string
      end
    end
  end
end
