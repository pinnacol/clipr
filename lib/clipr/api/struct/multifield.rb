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
               :theFields, [Field, 1]
      end
    end
  end
end
