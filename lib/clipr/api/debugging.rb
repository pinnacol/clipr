module Clipr
  module Api
    # Debugging Documentation
    module Debugging
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvDribbleActive, [:pointer], :void 
      # attach_function :EnvDribbleOff, [:pointer], :void 
      # attach_function :EnvDribbleOn, [:pointer], :void 
      # attach_function :EnvGetWatchItem, [:pointer], :void 
      # attach_function :EnvUnwatch, [:pointer], :void 
      # attach_function :EnvWatch, [:pointer], :void 
    end
  end
end