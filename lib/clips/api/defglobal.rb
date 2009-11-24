module Clips
  module Api
    # Defglobal Documentation
    module Defglobal
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :DefglobalModule, [], :void 
      # attach_function :FindDefglobal, [], :void 
      # attach_function :GetDefglobalList, [], :void 
      # attach_function :GetDefglobalName, [], :void 
      # attach_function :GetDefglobalPPForm, [], :void 
      # attach_function :GetDefglobalValue, [], :void 
      # attach_function :GetDefglobalValueForm, [], :void 
      # attach_function :GetDefglobalWatch, [], :void 
      # attach_function :GetGlobalsChanged, [], :void 
      # attach_function :GetNextDefglobal, [], :void 
      # attach_function :GetResetGlobals, [], :void 
      # attach_function :IsDefglobalDeletable, [], :void 
      # attach_function :ListDefglobals, [], :void 
      # attach_function :SetDefglobalValue, [], :void 
      # attach_function :SetDefglobalWatch, [], :void 
      # attach_function :SetGlobalsChanged, [], :void 
      # attach_function :SetResetGlobals, [], :void 
      # attach_function :ShowDefglobals, [], :void 
      # attach_function :Undefglobal, [], :void 
    end
  end
end