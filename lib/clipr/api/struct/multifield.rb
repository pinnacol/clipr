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
      # === Implementation Notes
      #
      # CLIPS uses a trick with multifields where theFields array is declared
      # as being of length 1, but in fact holds an arbitrary number of Fields.
      # This works in C because arrays do not do range checking, but it breaks
      # in FFI where range checking does occur.
      #
      # One solution is to set theFields extent to a large number, ie
      # something like this:
      #
      #   layout ... :theFields, [Field, 1000]
      #
      #   # breaks for i > 1000
      #   def each
      #     @begin.upto(@end) do |i|
      #       yield self[:theFields][i]
      #     end
      #   end
      #
      # A slower but more robust approach is what is done here, where each
      # manually increments the field pointer.
      class Multifield < FFI::Struct
        class << self
          def contents(obj)
            new(obj).collect {|field| field.contents }
          end
          
          def value(obj)
            new(obj).collect {|field| field.value }
          end
        end
        
        layout :busyCount, :uint,
               :depth, :short,
               :multifieldLength, :long,
               :next, :pointer,
               :theFields, Field
        
        include Enumerable
        FIELD_SIZE = Field.size
        
        def initialize(obj)
          super(obj[:value])
          
          @begin = obj[:begin]
          @end = obj[:end]
          @offest = self[:theFields].pointer.address
        end
        
        def each
          @begin.upto(@end) do |i|
            ptr = FFI::Pointer.new(@offest + i * FIELD_SIZE)
            yield Field.new(ptr)
          end
        end
      end
    end
  end
end
