module Clipr
  module Api
    # Agenda Documentation
    module Agenda
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvAddRunFunction, [:pointer], :void 
      # attach_function :EnvAgenda, [:pointer], :void 
      # attach_function :EnvClearFocusStack, [:pointer], :void 
      # attach_function :EnvDeleteActivation, [:pointer], :void 
      # attach_function :EnvFocus, [:pointer], :void 
      # attach_function :EnvGetActivationName, [:pointer], :void 
      # attach_function :EnvGetActivationPPForm, [:pointer], :void 
      # attach_function :EnvGetActivationSalience, [:pointer], :void 
      # attach_function :EnvGetAgendaChanged, [:pointer], :void 
      # attach_function :EnvGetFocus, [:pointer], :void 
      # attach_function :EnvGetFocusStack, [:pointer], :void 
      # attach_function :EnvGetNextActivation, [:pointer], :void 
      # attach_function :EnvGetSalienceEvaluation, [:pointer], :void 
      # attach_function :EnvGetStrategy, [:pointer], :void 
      # attach_function :EnvListFocusStack, [:pointer], :void 
      # attach_function :EnvPopFocus, [:pointer], :void 
      # attach_function :EnvRefreshAgenda, [:pointer], :void 
      # attach_function :EnvRemoveRunFunction, [:pointer], :void 
      # attach_function :EnvReorderAgenda, [:pointer], :void 
      attach_function :EnvRun, [:pointer, :long_long], :long_long 
      # attach_function :EnvSetActivationSalience, [:pointer], :void 
      # attach_function :EnvSetAgendaChanged, [:pointer], :void 
      # attach_function :EnvSetSalienceEvaluation, [:pointer], :void 
      # attach_function :EnvSetStrategy, [:pointer], :void 
    end
  end
end