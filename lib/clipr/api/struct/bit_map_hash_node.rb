module Clipr
  module Api
    module Struct
      # ==== Definition
      #
      #   [symbol.h]
      #   struct bitMapHashNode
      #     {
      #      struct bitMapHashNode *next;
      #      long count;
      #      int depth;
      #      unsigned int permanent : 1;
      #      unsigned int markedEphemeral : 1;
      #      unsigned int neededBitMap : 1;
      #      unsigned int bucket : 29;
      #      char *contents;
      #      unsigned short size;
      #     };
      #
      # (not presently used by clipr... exists for completeness)
      class BitMapHashNode < FFI::Struct
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
               :contents, :string,
               :size, :ushort
      end
    end
  end
end