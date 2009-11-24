module Clips
  module Api
    # Fact Documentation
    module Fact
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvAssert, [:pointer], :void 
      # attach_function :EnvAssertString, [:pointer], :void 
      # attach_function :EnvAssignFactSlotDefaults, [:pointer], :void 
      # attach_function :EnvCreateFact, [:pointer], :void 
      # attach_function :EnvDecrementFactCount, [:pointer], :void 
      # attach_function :EnvFactDeftemplate, [:pointer], :void 
      # attach_function :EnvFactExistp, [:pointer], :void 
      # attach_function :EnvFactIndex, [:pointer], :void 
      # attach_function :EnvFacts, [:pointer], :void 
      # attach_function :EnvFactSlotNames, [:pointer], :void 
      # attach_function :EnvGetFactDuplication, [:pointer], :void 
      # attach_function :EnvGetFactList, [:pointer], :void 
      # attach_function :EnvGetFactListChanged, [:pointer], :void 
      # attach_function :EnvGetFactPPForm, [:pointer], :void 
      # attach_function :EnvGetFactSlot, [:pointer], :void 
      # attach_function :EnvGetNextFact, [:pointer], :void 
      # attach_function :EnvGetNextFactInTemplate, [:pointer], :void 
      # attach_function :EnvIncrementFactCount, [:pointer], :void 
      # attach_function :EnvLoadFacts, [:pointer], :void 
      # attach_function :EnvLoadFactsFromString, [:pointer], :void 
      # attach_function :EnvPPFact, [:pointer], :void 
      # attach_function :EnvPutFactSlot, [:pointer], :void 
      # attach_function :EnvRetract, [:pointer], :void 
      attach_function :EnvSaveFacts, [:pointer, :string, :int, :pointer], :int
      # attach_function :EnvSetFactDuplication, [:pointer], :void 
      # attach_function :EnvSetFactListChanged, [:pointer], :void 
    end
  end
end