module Clips
  module Api
    # Defgeneric Documentation
    module Defgeneric
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :DefgenericModule, [], :void 
      # attach_function :FindDefgeneric, [], :void 
      # attach_function :GetDefgenericList, [], :void 
      # attach_function :GetDefgenericName, [], :void 
      # attach_function :GetDefgenericPPForm, [], :void 
      # attach_function :GetDefgenericWatch, [], :void 
      # attach_function :GetNextDefgeneric, [], :void 
      # attach_function :IsDefgenericDeletable, [], :void 
      # attach_function :ListDefgenerics, [], :void 
      # attach_function :SetDefgenericWatch, [], :void 
      # attach_function :Undefgeneric, [], :void 
    end
  end
end