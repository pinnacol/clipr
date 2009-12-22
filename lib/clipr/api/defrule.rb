module Clipr
  module Api
    # Defrule Documentation
    module Defrule
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvDefruleHasBreakpoint, [:pointer], :void 
      # attach_function :EnvDefruleModule, [:pointer], :void 
      # attach_function :EnvFindDefrule, [:pointer], :void 
      # attach_function :EnvGetDefruleList, [:pointer], :void 
      # attach_function :EnvGetDefruleName, [:pointer], :void 
      # attach_function :EnvGetDefrulePPForm, [:pointer], :void 
      # attach_function :EnvGetDefruleWatchActivations, [:pointer], :void 
      # attach_function :EnvGetDefruleWatchFirings, [:pointer], :void 
      # attach_function :EnvGetIncrementalReset, [:pointer], :void 
      # attach_function :EnvGetNextDefrule, [:pointer], :void 
      # attach_function :EnvIsDefruleDeletable, [:pointer], :void 
      # attach_function :EnvListDefrules, [:pointer], :void 
      # attach_function :EnvMatches, [:pointer], :void 
      # attach_function :EnvRefresh, [:pointer], :void 
      # attach_function :EnvRemoveBreak, [:pointer], :void 
      # attach_function :EnvSetBreak, [:pointer], :void 
      # attach_function :EnvSetDefruleWatchActivations, [:pointer], :void 
      # attach_function :EnvSetDefruleWatchFirings, [:pointer], :void 
      # attach_function :EnvSetIncrementalReset, [:pointer], :void 
      # attach_function :EnvShowBreaks, [:pointer], :void 
      # attach_function :EnvUndefrule, [:pointer], :void 
    end
  end
end