require 'clipr/api/struct/field'

module Clipr
  module Api
    module Struct
      # ==== Definition
      #
      #   [multifld.h]
      #   struct multifield
      #     {
      #      unsigned busyCount;
      #      short depth;
      #      long multifieldLength;
      #      struct multifield *next;
      #      struct field theFields[1];
      #     };
      #
      class Multifield < FFI::Struct
        class << self
          def contents(obj)
            fields(obj) {|field| field.contents }
          end
          
          def value(obj)
            fields(obj) {|field| field.value }
          end
          
          private
          
          # Yields each field in the object to the block.
          #
          # === Implementation Notes
          #
          # CLIPS uses a trick with multifields where theFields array is
          # declared as being of length 1, but hold an arbitrary number of
          # Fields.  This works in C because there is no range checking on an
          # array, however it breaks in FFI where range checking does occur.
          #
          # One solution is to set theFields extent to a large number, ie:
          #
          #   layout :theFields, [Field, 1000]
          #
          #   # breaks for i > 1000
          #   def fields(obj)
          #     fields = new(obj[:value])[:theFields]
          #     obj[:begin].upto(obj[:end]) do |i|
          #       yield(fields[i])
          #     end
          #   end
          #
          # A slower but more robust approach is what is done here, where the
          # iterator manually increments the field pointer.
          def fields(obj) # :nodoc:
            offest = new(obj[:value])[:theFields].pointer.address
            size = Field.size
            
            values = []
            obj[:begin].upto(obj[:end]) do |i|
              pointer = FFI::Pointer.new(offest + i * size)
              values << yield(Field.new(pointer))
            end
            values
          end
        end
        
        layout :busyCount, :uint,
               :depth, :short,
               :multifieldLength, :long,
               :next, :pointer,
               :theFields, Field
      end
    end
  end
end
