module Clips
  module Api
    # Defrule Documentation
    module Defrule
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :DefruleHasBreakpoint, [], :void 
      # attach_function :DefruleModule, [], :void 
      # attach_function :FindDefrule, [], :void 
      # attach_function :GetDefruleList, [], :void 
      # attach_function :GetDefruleName, [], :void 
      # attach_function :GetDefrulePPForm, [], :void 
      # attach_function :GetDefruleWatchActivations, [], :void 
      # attach_function :GetDefruleWatchFirings, [], :void 
      # attach_function :GetIncrementalReset, [], :void 
      # attach_function :GetNextDefrule, [], :void 
      # attach_function :IsDefruleDeletable, [], :void 
      # attach_function :ListDefrules, [], :void 
      # attach_function :Matches, [], :void 
      # attach_function :Refresh, [], :void 
      # attach_function :RemoveBreak, [], :void 
      # attach_function :SetBreak, [], :void 
      # attach_function :SetDefruleWatchActivations, [], :void 
      # attach_function :SetDefruleWatchFirings, [], :void 
      # attach_function :SetIncrementalReset, [], :void 
      # attach_function :ShowBreaks, [], :void 
      # attach_function :Undefrule, [], :void 
    end
  end
end