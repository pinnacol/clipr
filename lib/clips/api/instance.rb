module Clips
  module Api
    # Instance Documentation
    module Instance
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvBinaryLoadInstances, [:pointer], :void 
      # attach_function :EnvBinarySaveInstances, [:pointer], :void 
      # attach_function :EnvCreateRawInstance, [:pointer], :void 
      # attach_function :EnvDecrementInstanceCount, [:pointer], :void 
      # attach_function :EnvDeleteInstance, [:pointer], :void 
      # attach_function :EnvDirectGetSlot, [:pointer], :void 
      # attach_function :EnvDirectPutSlot, [:pointer], :void 
      # attach_function :EnvFindInstance, [:pointer], :void 
      # attach_function :EnvGetInstanceClass, [:pointer], :void 
      # attach_function :EnvGetInstanceName, [:pointer], :void 
      # attach_function :EnvGetInstancePPForm, [:pointer], :void 
      # attach_function :EnvGetInstancesChanged, [:pointer], :void 
      # attach_function :EnvGetNextInstance, [:pointer], :void 
      # attach_function :EnvGetNextInstanceInClass, [:pointer], :void 
      # attach_function :EnvGetNextInstanceInClassAndSubclasses, [:pointer], :void 
      # attach_function :EnvIncrementInstanceCount, [:pointer], :void 
      # attach_function :EnvInstances, [:pointer], :void 
      # attach_function :EnvLoadInstances, [:pointer], :void 
      # attach_function :EnvLoadInstancesFromString, [:pointer], :void 
      # attach_function :EnvMakeInstance, [:pointer], :void 
      # attach_function :EnvRestoreInstances, [:pointer], :void 
      # attach_function :EnvRestoreInstancesFromString, [:pointer], :void 
      # attach_function :EnvSaveInstances, [:pointer], :void 
      # attach_function :EnvSend, [:pointer], :void 
      # attach_function :EnvSetInstancesChanged, [:pointer], :void 
      # attach_function :EnvUnmakeInstance, [:pointer], :void 
      # attach_function :EnvValidInstanceAddress, [:pointer], :void 
      # attach_function :EnvFunctions, [:pointer], :void 
      # attach_function :EnvFindDefmessageHandler, [:pointer], :void 
      # attach_function :EnvGetDefmessageHandlerList, [:pointer], :void 
      # attach_function :EnvGetDefmessageHandlerName, [:pointer], :void 
      # attach_function :EnvGetDefmessageHandlerPPForm, [:pointer], :void 
      # attach_function :EnvGetDefmessageHandlerType, [:pointer], :void 
      # attach_function :EnvGetDefmessageHandlerWatch, [:pointer], :void 
      # attach_function :EnvGetNextDefmessageHandler, [:pointer], :void 
      # attach_function :EnvIsDefmessageHandlerDeletable, [:pointer], :void 
      # attach_function :EnvListDefmessageHandlers, [:pointer], :void 
      # attach_function :EnvPreviewSend, [:pointer], :void 
      # attach_function :EnvSetDefmessageHandlerWatch, [:pointer], :void 
      # attach_function :EnvUndefmessageHandler, [:pointer], :void 
    end
  end
end