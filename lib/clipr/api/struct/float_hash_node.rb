module Clipr
  module Api
    module Struct
      # ==== Definition
      #
      #   [symbol.h]
      #   struct floatHashNode
      #     {
      #      struct floatHashNode *next;
      #      long count;
      #      int depth;
      #      unsigned int permanent : 1;
      #      unsigned int markedEphemeral : 1;
      #      unsigned int neededFloat : 1;
      #      unsigned int bucket : 29;
      #      double contents;
      #     };
      #
      class FloatHashNode < FFI::Struct
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
               :contents, :double
      end
    end
  end
end
