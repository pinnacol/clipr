require 'clipr/api/struct/symbol_hash_node'
require 'clipr/api/struct/integer_hash_node'
require 'clipr/api/struct/float_hash_node'
require 'clipr/api/struct/multifield'
require 'clipr/api/types'

module Clipr
  module Api
    module Struct
      include Types

      module_function
      
      def struct(type)
        case type
        when SYMBOL     then SymbolHashNode
        when STRING     then SymbolHashNode
        when INTEGER    then IntegerHashNode
        when FLOAT      then FloatHashNode
        when MULTIFIELD then Multifield
        else nil
        end
      end
      
      def contents(obj)
        structure = struct(obj[:type])
        structure ? structure.contents(obj) : obj[:value]
      end
      
      def value(obj)
        structure = struct(obj[:type])
        structure ? structure.value(obj) : obj[:value]
      end
    end
  end
end