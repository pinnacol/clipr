require 'clipr/api/struct'
require 'clipr/api/types'

module Clipr
  module Api
    
    # ==== Definition
    #
    #   [evaluatn.h]
    #   struct dataObject
    #     {
    #      void *supplementalInfo;
    #      unsigned short type;
    #      void *value;
    #      long begin;
    #      long end;
    #      struct dataObject *next;
    #     };
    #
    class DataObject < FFI::Struct
      class << self
        
        # Initializes a new DataObject with the specified attributes.
        def intern(attrs={})
          obj = new
          attrs.each_pair {|key, value| obj[key] = value }
          obj
        end
      end
      
      layout :supplementalInfo, :pointer,
             :type, :ushort,
             :value, :pointer,
             :begin, :long,
             :end, :long,
             :next, :pointer
      
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
      
      # Returns the value for self converted as follows:
      #
      # * primitive types are resolved into their corresponding objects
      #   (FLOAT, INTEGER, SYMBOL, STRING)
      # * other types are returned directly as FFI pointers
      #   (FACT_ADDRESS, EXTERNAL_ADDRESS, INSTANCE_ADDRESS ... )
      #
      # By default value will duplicate SYMBOL and STRING outputs.  This
      # behavior can be turned off by specifying dup = false, but be mindful
      # of the consequences, as discussed in the apg:
      #
      #   Do not store the pointer returned by DOToString or DOPToString as part
      #   of a permanent data structure. When CLIPS performs garbage collection
      #   on symbols and strings, the pointer reference to the string may be
      #   rendered invalid. To store a permanent reference to a string, allocate
      #   storage for a copy of the string and then copy the string returned by
      #   DOToString or DOPToString to the copy’s storage area.
      #
      def value
        Struct.value(self)
      end
    end
  end
end
