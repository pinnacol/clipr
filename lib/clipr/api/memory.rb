module Clipr
  module Api
    # Memory Documentation
    module Memory
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvGetConserveMemory, [:pointer], :void 
      # attach_function :EnvMemRequests, [:pointer], :void 
      # attach_function :EnvMemUsed, [:pointer], :void 
      # attach_function :EnvReleaseMem, [:pointer], :void 
      # attach_function :EnvSetConserveMemory, [:pointer], :void 
      # attach_function :EnvSetOutOfMemoryFunction, [:pointer], :void 
    end
  end
end