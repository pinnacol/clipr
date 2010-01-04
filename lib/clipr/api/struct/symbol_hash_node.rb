module Clipr
  module Api
    module Struct
      # ==== Definition
      #
      #   [symbol.h]
      #   struct symbolHashNode
      #     {
      #      struct symbolHashNode *next;
      #      long count;
      #      int depth;
      #      unsigned int permanent : 1;
      #      unsigned int markedEphemeral : 1;
      #      unsigned int neededSymbol : 1;
      #      unsigned int bucket : 29;
      #      char *contents;
      #     };
      #
      class SymbolHashNode < FFI::Struct
        class << self
          def contents(obj)
            new(obj[:value])[:contents]
          end
          
          def value(obj)
            value = contents(obj)
            
            case value
            when "TRUE"  then true
            when "FALSE" then false
            else value.to_sym
            end
          end
        end
        
        layout :next, :pointer,
               :count, :long,
               :depth, :int,
               :bits, :uint32,
               :contents, :string
      end
    end
  end
end
