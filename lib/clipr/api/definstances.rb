module Clipr
  module Api
    # Definstances Documentation
    module Definstances
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvDefinstancesModule, [:pointer], :void 
      # attach_function :EnvFindDefinstances, [:pointer], :void 
      # attach_function :EnvGetDefinstancesList, [:pointer], :void 
      # attach_function :EnvGetDefinstancesName, [:pointer], :void 
      # attach_function :EnvGetDefinstancesPPForm, [:pointer], :void 
      # attach_function :EnvGetNextDefinstances, [:pointer], :void 
      # attach_function :EnvIsDefinstancesDeletable, [:pointer], :void 
      # attach_function :EnvListDefinstances, [:pointer], :void 
      # attach_function :EnvUndefinstances, [:pointer], :void 
    end
  end
end