module Clipr
  module Api
    # Fact Documentation
    module Fact
      extend FFI::Library
      ffi_lib DYLIB
      
      attach_function :EnvAssert, [:pointer, :pointer], :pointer 
      attach_function :EnvAssertString, [:pointer, :string], :pointer 
      attach_function :EnvAssignFactSlotDefaults, [:pointer, :pointer], :int 
      attach_function :EnvCreateFact, [:pointer, :pointer], :pointer 
      # attach_function :EnvDecrementFactCount, [:pointer], :void 
      attach_function :EnvFactDeftemplate, [:pointer, :pointer], :pointer
      # attach_function :EnvFactExistp, [:pointer], :void 
      # attach_function :EnvFactIndex, [:pointer], :void 
      attach_function :EnvFacts, [:pointer, :string, :pointer, :long_long, :long_long, :long_long], :void 
      # attach_function :EnvFactSlotNames, [:pointer], :void 
      # attach_function :EnvGetFactDuplication, [:pointer], :void 
      # attach_function :EnvGetFactList, [:pointer], :void 
      # attach_function :EnvGetFactListChanged, [:pointer], :void 
      # attach_function :EnvGetFactPPForm, [:pointer], :void 
      attach_function :EnvGetFactSlot, [:pointer, :pointer, :string, :pointer], :int 
      # attach_function :EnvGetNextFact, [:pointer], :void 
      # attach_function :EnvGetNextFactInTemplate, [:pointer], :void 
      # attach_function :EnvIncrementFactCount, [:pointer], :void 
      # attach_function :EnvLoadFacts, [:pointer], :void 
      # attach_function :EnvLoadFactsFromString, [:pointer], :void 
      # attach_function :EnvPPFact, [:pointer], :void 
      attach_function :EnvPutFactSlot, [:pointer, :pointer, :string, :pointer], :void 
      # attach_function :EnvRetract, [:pointer], :void 
      attach_function :EnvSaveFacts, [:pointer, :string, :int, :pointer], :int
      # attach_function :EnvSetFactDuplication, [:pointer], :void 
      # attach_function :EnvSetFactListChanged, [:pointer], :void 
    end
  end
end