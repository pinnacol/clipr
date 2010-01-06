module Clipr
  module Api
    # Deftemplate Documentation
    module Deftemplate
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvDeftemplateModule, [:pointer], :void 
      # attach_function :EnvDeftemplateSlotAllowedValues, [:pointer], :void 
      # attach_function :EnvDeftemplateSlotCardinality, [:pointer], :void 
      # attach_function :EnvDeftemplateSlotDefaultP, [:pointer], :void 
      # attach_function :EnvDeftemplateSlotDefaultValue, [:pointer], :void 
      # attach_function :EnvDeftemplateSlotExistP, [:pointer], :void 
      # attach_function :EnvDeftemplateSlotMultiP, [:pointer], :void 
      attach_function :EnvDeftemplateSlotNames, [:pointer, :pointer, :pointer], :void 
      # attach_function :EnvDeftemplateSlotRange, [:pointer], :void 
      # attach_function :EnvDeftemplateSlotSingleP, [:pointer], :void 
      # attach_function :EnvDeftemplateSlotTypes, [:pointer], :void 
      attach_function :EnvFindDeftemplate, [:pointer, :string], :pointer 
      # attach_function :EnvGetDeftemplateList, [:pointer], :void 
      # attach_function :EnvGetDeftemplateName, [:pointer], :void # see GetConstructNameString
      # attach_function :EnvGetDeftemplatePPForm, [:pointer], :void 
      # attach_function :EnvGetDeftemplateWatch, [:pointer], :void 
      # attach_function :EnvGetNextDeftemplate, [:pointer], :void 
      # attach_function :EnvIsDeftemplateDeletable, [:pointer], :void 
      # attach_function :EnvListDeftemplates, [:pointer], :void 
      # attach_function :EnvSetDeftemplateWatch, [:pointer], :void 
      # attach_function :EnvUndeftemplate, [:pointer], :void 
    end
  end
end