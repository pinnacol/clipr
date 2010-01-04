module Clipr
  module Api
    module Struct
      # ==== Definition
      #
      #   [multifld.h]
      #   struct field
      #     {
      #      unsigned short type;
      #      void *value;
      #     };
      #
      class Field < FFI::Struct
        layout :type, :ushort,
               :value, :pointer
        
        
      end
    end
  end
end
