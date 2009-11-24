module Clips
  module Api
    # Defmodule Documentation
    module Defmodule
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :FindDefmodule, [], :void 
      # attach_function :GetCurrentModule, [], :void 
      # attach_function :GetDefmoduleList, [], :void 
      # attach_function :GetDefmoduleName, [], :void 
      # attach_function :GetDefmodulePPForm, [], :void 
      # attach_function :GetNextDefmodule, [], :void 
      # attach_function :ListDefmodules, [], :void 
      # attach_function :SetCurrentModule, [], :void 
    end
  end
end