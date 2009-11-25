module Clips
  module Api
    # Io Documentation
    module Io
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvExitRouter, [:pointer], :void 
      # attach_function :EnvGetcRouter, [:pointer], :void 
      # attach_function :EnvPrintRouter, [:pointer], :void 
      # attach_function :EnvUngetcRouter, [:pointer], :void 
    end
  end
end