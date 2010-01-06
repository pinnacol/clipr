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
        
        
        # Returns the type for self.
        def type
          self[:type]
        end

        # Returns type converted to the corresponding type string, or nil for
        # unknown types.
        def type_str
          Types.type_str(type)
        end

        def contents
          Struct.contents(self)
        end

        def value
          Struct.value(self)
        end
      end
    end
  end
end
