module Clips
  module Api
    # Defclass Documentation
    module Defclass
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvBrowseClasses, [:pointer], :void 
      # attach_function :EnvClassAbstractP, [:pointer], :void 
      # attach_function :EnvClassReactiveP, [:pointer], :void 
      # attach_function :EnvClassSlots, [:pointer], :void 
      # attach_function :EnvClassSubclasses, [:pointer], :void 
      # attach_function :EnvClassSuperclasses, [:pointer], :void 
      # attach_function :EnvDefclassModule, [:pointer], :void 
      # attach_function :EnvDescribeClass, [:pointer], :void 
      # attach_function :EnvFindDefclass, [:pointer], :void 
      # attach_function :EnvGetClassDefaultsMode, [:pointer], :void 
      # attach_function :EnvGetDefclassList, [:pointer], :void 
      # attach_function :EnvGetDefclassName, [:pointer], :void 
      # attach_function :EnvGetDefclassPPForm, [:pointer], :void 
      # attach_function :EnvGetDefclassWatchInstances, [:pointer], :void 
      # attach_function :EnvGetDefclassWatchSlots, [:pointer], :void 
      # attach_function :EnvGetNextDefclass, [:pointer], :void 
      # attach_function :EnvIsDefclassDeletable, [:pointer], :void 
      # attach_function :EnvListDefclasses, [:pointer], :void 
      # attach_function :EnvSetClassDefaultsMode, [:pointer], :void 
      # attach_function :EnvSetDefclassWatchInstances, [:pointer], :void 
      # attach_function :EnvSetDefclassWatchSlots, [:pointer], :void 
      # attach_function :EnvSlotAllowedClasses, [:pointer], :void 
      # attach_function :EnvSlotAllowedValues, [:pointer], :void 
      # attach_function :EnvSlotCardinality, [:pointer], :void 
      # attach_function :EnvSlotDefaultValue, [:pointer], :void 
      # attach_function :EnvSlotDirectAccessP, [:pointer], :void 
      # attach_function :EnvSlotExistP, [:pointer], :void 
      # attach_function :EnvSlotFacets, [:pointer], :void 
      # attach_function :EnvSlotInitableP, [:pointer], :void 
      # attach_function :EnvSlotPublicP, [:pointer], :void 
      # attach_function :EnvSlotRange, [:pointer], :void 
      # attach_function :EnvSlotSources, [:pointer], :void 
      # attach_function :EnvSlotTypes, [:pointer], :void 
      # attach_function :EnvSlotWritableP, [:pointer], :void 
      # attach_function :EnvSubclassP, [:pointer], :void 
      # attach_function :EnvSuperclassP, [:pointer], :void 
      # attach_function :EnvUndefclass, [:pointer], :void 
    end
  end
end