module Clipr
  module Api
    # == Definition
    # 
    # See constant.h
    #
    module Types
      FLOAT            = 0
      INTEGER          = 1
      SYMBOL           = 2
      STRING           = 3
      MULTIFIELD       = 4
      EXTERNAL_ADDRESS = 5
      FACT_ADDRESS     = 6
      INSTANCE_ADDRESS = 7
      INSTANCE_NAME    = 8
      
      module_function
      
      # Returns the string for the specified type.
      def type_str(type)
        constant = constants.find {|const| const_get(const) == type }
        constant ? constant.to_s : nil
      end
    end
  end
end