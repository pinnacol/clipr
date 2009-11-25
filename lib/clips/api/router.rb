module Clips
  module Api
    # Router Documentation
    module Router
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvActivateRouter, [:pointer], :void 
      # attach_function :EnvAddRouter, [:pointer], :void 
      # attach_function :EnvDeactivateRouter, [:pointer], :void 
      # attach_function :EnvDeleteRouter, [:pointer], :void 
    end
  end
end