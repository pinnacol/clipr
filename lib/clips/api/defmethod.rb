module Clips
  module Api
    # Defmethod Documentation
    module Defmethod
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvGetDefmethodDescription, [:pointer], :void 
      # attach_function :EnvGetDefmethodList, [:pointer], :void 
      # attach_function :EnvGetDefmethodPPForm, [:pointer], :void 
      # attach_function :EnvGetDefmethodWatch, [:pointer], :void 
      # attach_function :EnvGetMethodRestrictions, [:pointer], :void 
      # attach_function :EnvGetNextDefmethod, [:pointer], :void 
      # attach_function :EnvIsDefmethodDeletable, [:pointer], :void 
      # attach_function :EnvListDefmethods, [:pointer], :void 
      # attach_function :EnvSetDefmethodWatch, [:pointer], :void 
      # attach_function :EnvUndefmethod, [:pointer], :void 
    end
  end
end