module Clipr
  module Api
    module Struct
      # ==== Definition
      #
      #   [symbol.h]
      #   struct externalAddressHashNode
      #     {
      #      struct externalAddressHashNode *next;
      #      long count;
      #      int depth;
      #      unsigned int permanent : 1;
      #      unsigned int markedEphemeral : 1;
      #      unsigned int neededPointer : 1;
      #      unsigned int bucket : 29;
      #      void *externalAddress;
      #      unsigned short type;
      #     };
      #
      # (not presently used by clipr... exists for completeness)
      class ExternalAddressHashNode < FFI::Struct
        class << self
          def contents(obj)
            new(obj[:value])[:externalAddress]
          end
          
          alias value contents
        end
        
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32,
               :externalAddress, :pointer,
               :type, :ushort
      end
    end
  end
end