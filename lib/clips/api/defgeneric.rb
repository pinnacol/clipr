module Clips
  module Api
    # Defgeneric Documentation
    module Defgeneric
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvDefgenericModule, [:pointer], :void 
      # attach_function :EnvFindDefgeneric, [:pointer], :void 
      # attach_function :EnvGetDefgenericList, [:pointer], :void 
      # attach_function :EnvGetDefgenericName, [:pointer], :void 
      # attach_function :EnvGetDefgenericPPForm, [:pointer], :void 
      # attach_function :EnvGetDefgenericWatch, [:pointer], :void 
      # attach_function :EnvGetNextDefgeneric, [:pointer], :void 
      # attach_function :EnvIsDefgenericDeletable, [:pointer], :void 
      # attach_function :EnvListDefgenerics, [:pointer], :void 
      # attach_function :EnvSetDefgenericWatch, [:pointer], :void 
      # attach_function :EnvUndefgeneric, [:pointer], :void 
    end
  end
end