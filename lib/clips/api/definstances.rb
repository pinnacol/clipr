module Clips
  module Api
    # Definstances Documentation
    module Definstances
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :DefinstancesModule, [], :void 
      # attach_function :FindDefinstances, [], :void 
      # attach_function :GetDefinstancesList, [], :void 
      # attach_function :GetDefinstancesName, [], :void 
      # attach_function :GetDefinstancesPPForm, [], :void 
      # attach_function :GetNextDefinstances, [], :void 
      # attach_function :IsDefinstancesDeletable, [], :void 
      # attach_function :ListDefinstances, [], :void 
      # attach_function :Undefinstances, [], :void 
    end
  end
end