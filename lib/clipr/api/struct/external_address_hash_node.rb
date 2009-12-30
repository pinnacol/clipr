module Clipr
  module Api
    module Struct
      # /************************************************************/
      # /* externalAddressHashNode STRUCTURE:                                */
      # /************************************************************/
      # struct externalAddressHashNode
      #   {
      #    struct externalAddressHashNode *next;
      #    long count;
      #    int depth;
      #    unsigned int permanent : 1;
      #    unsigned int markedEphemeral : 1;
      #    unsigned int neededPointer : 1;
      #    unsigned int bucket : 29;
      #    void *externalAddress;
      #    unsigned short type;
      #   };
      #
      class ExternalAddressHashNode < FFI::Struct
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