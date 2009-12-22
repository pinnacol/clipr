module Clipr
  module Api
    # Deffacts Documentation
    module Deffacts
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvDeffactsModule, [:pointer], :void 
      # attach_function :EnvFindDeffacts, [:pointer], :void 
      # attach_function :EnvGetDeffactsList, [:pointer], :void 
      # attach_function :EnvGetDeffactsName, [:pointer], :void 
      # attach_function :EnvGetDeffactsPPForm, [:pointer], :void 
      # attach_function :EnvGetNextDeffacts, [:pointer], :void 
      # attach_function :EnvIsDeffactsDeletable, [:pointer], :void 
      # attach_function :EnvListDeffacts, [:pointer], :void 
      # attach_function :EnvUndeffacts, [:pointer], :void 
    end
  end
end