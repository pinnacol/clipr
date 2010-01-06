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
            fields(obj) {|field| Struct.contents(field) }
          end
          
          def value(obj)
            fields(obj) {|field| Struct.value(field) }
          end
          
          private
          
          def fields(obj) # :nodoc:
            fields = new(obj[:value])[:theFields]
            
            values = []
            obj[:begin].upto(obj[:end]) do |i|
              values << yield(fields[i])
            end
            values
          end
        end
        
        layout :busyCount, :uint,
               :depth, :short,
               :multifieldLength, :long,
               :next, :pointer,
               :theFields, [Field, 100000]
        
        # Note theFields needs a large index because FFI 0.6.0 does range
        # checking -- if it is set to 1 then IndexErrors result. Apparently
        # CLIPS is being tricky in that it declares theFields as an array of
        # length 1 but manages storage to put multiple fields in the array.
      end
    end
  end
end
