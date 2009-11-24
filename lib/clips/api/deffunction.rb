module Clips
  module Api
    # Deffunction Documentation
    module Deffunction
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvDeffunctionModule, [:pointer], :void 
      # attach_function :EnvFindDeffunction, [:pointer], :void 
      # attach_function :EnvGetDeffunctionList, [:pointer], :void 
      # attach_function :EnvGetDeffunctionName, [:pointer], :void 
      # attach_function :EnvGetDeffunctionPPForm, [:pointer], :void 
      # attach_function :EnvGetDeffunctionWatch, [:pointer], :void 
      # attach_function :EnvGetNextDeffunction, [:pointer], :void 
      # attach_function :EnvIsDeffunctionDeletable, [:pointer], :void 
      # attach_function :EnvListDeffunctions, [:pointer], :void 
      # attach_function :EnvSetDeffunctionWatch, [:pointer], :void 
      # attach_function :EnvUndeffunction, [:pointer], :void 
    end
  end
end