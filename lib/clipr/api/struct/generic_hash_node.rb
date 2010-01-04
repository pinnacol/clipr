module Clipr
  module Api
    module Struct
      # ==== Definition
      #
      #   [symbol.h]
      #   struct genericHashNode
      #     {
      #      struct genericHashNode *next;
      #      long count;
      #      int depth;
      #      unsigned int permanent : 1;
      #      unsigned int markedEphemeral : 1;
      #      unsigned int needed : 1;
      #      unsigned int bucket : 29;
      #     };
      #
      # (not presently used by clipr... exists for completeness)
      class GenericHashNode < FFI::Struct
        class << self
          def contents(obj)
            nil
          end
          
          alias value contents
        end
        
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32
      end
    end
  end
end