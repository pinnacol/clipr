module Clips
  module Api
    # Defmethod Documentation
    module Defmethod
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :GetDefmethodDescription, [], :void 
      # attach_function :GetDefmethodList, [], :void 
      # attach_function :GetDefmethodPPForm, [], :void 
      # attach_function :GetDefmethodWatch, [], :void 
      # attach_function :GetMethodRestrictions, [], :void 
      # attach_function :GetNextDefmethod, [], :void 
      # attach_function :IsDefmethodDeletable, [], :void 
      # attach_function :ListDefmethods, [], :void 
      # attach_function :SetDefmethodWatch, [], :void 
      # attach_function :Undefmethod, [], :void 
    end
  end
end