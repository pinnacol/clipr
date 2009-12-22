module Clipr
  module Api
    # Defmodule Documentation
    module Defmodule
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvFindDefmodule, [:pointer], :void 
      # attach_function :EnvGetCurrentModule, [:pointer], :void 
      # attach_function :EnvGetDefmoduleList, [:pointer], :void 
      # attach_function :EnvGetDefmoduleName, [:pointer], :void 
      # attach_function :EnvGetDefmodulePPForm, [:pointer], :void 
      # attach_function :EnvGetNextDefmodule, [:pointer], :void 
      # attach_function :EnvListDefmodules, [:pointer], :void 
      # attach_function :EnvSetCurrentModule, [:pointer], :void 
    end
  end
end