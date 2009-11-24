module Clips
  module Api
    # Fact Documentation
    module Fact
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :Assert, [], :void 
      # attach_function :AssertString, [], :void 
      # attach_function :AssignFactSlotDefaults, [], :void 
      # attach_function :CreateFact, [], :void 
      # attach_function :DecrementFactCount, [], :void 
      # attach_function :FactDeftemplate, [], :void 
      # attach_function :FactExistp, [], :void 
      # attach_function :FactIndex, [], :void 
      # attach_function :Facts, [], :void 
      # attach_function :FactSlotNames, [], :void 
      # attach_function :GetFactDuplication, [], :void 
      # attach_function :GetFactList, [], :void 
      # attach_function :GetFactListChanged, [], :void 
      # attach_function :GetFactPPForm, [], :void 
      # attach_function :GetFactSlot, [], :void 
      # attach_function :GetNextFact, [], :void 
      # attach_function :GetNextFactInTemplate, [], :void 
      # attach_function :IncrementFactCount, [], :void 
      # attach_function :LoadFacts, [], :void 
      # attach_function :LoadFactsFromString, [], :void 
      # attach_function :PPFact, [], :void 
      # attach_function :PutFactSlot, [], :void 
      # attach_function :Retract, [], :void 
      # attach_function :SaveFacts, [], :void 
      # attach_function :SetFactDuplication, [], :void 
      # attach_function :SetFactListChanged, [], :void 
      
      attach_function :EnvSaveFacts, [:pointer, :string, :int, :pointer], :int
    end
  end
end