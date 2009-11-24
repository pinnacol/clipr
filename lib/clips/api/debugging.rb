module Clips
  module Api
    # Debugging Documentation
    module Debugging
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :DribbleActive, [], :void 
      # attach_function :DribbleOff, [], :void 
      # attach_function :DribbleOn, [], :void 
      # attach_function :GetWatchItem, [], :void 
      # attach_function :Unwatch, [], :void 
      # attach_function :Watch, [], :void 
    end
  end
end