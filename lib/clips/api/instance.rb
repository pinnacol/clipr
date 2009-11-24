module Clips
  module Api
    # Instance Documentation
    module Instance
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :BinaryLoadInstances, [], :void 
      # attach_function :BinarySaveInstances, [], :void 
      # attach_function :CreateRawInstance, [], :void 
      # attach_function :DecrementInstanceCount, [], :void 
      # attach_function :DeleteInstance, [], :void 
      # attach_function :DirectGetSlot, [], :void 
      # attach_function :DirectPutSlot, [], :void 
      # attach_function :FindInstance, [], :void 
      # attach_function :GetInstanceClass, [], :void 
      # attach_function :GetInstanceName, [], :void 
      # attach_function :GetInstancePPForm, [], :void 
      # attach_function :GetInstancesChanged, [], :void 
      # attach_function :GetNextInstance, [], :void 
      # attach_function :GetNextInstanceInClass, [], :void 
      # attach_function :GetNextInstanceInClassAndSubclasses, [], :void 
      # attach_function :IncrementInstanceCount, [], :void 
      # attach_function :Instances, [], :void 
      # attach_function :LoadInstances, [], :void 
      # attach_function :LoadInstancesFromString, [], :void 
      # attach_function :MakeInstance, [], :void 
      # attach_function :RestoreInstances, [], :void 
      # attach_function :RestoreInstancesFromString, [], :void 
      # attach_function :SaveInstances, [], :void 
      # attach_function :Send, [], :void 
      # attach_function :SetInstancesChanged, [], :void 
      # attach_function :UnmakeInstance, [], :void 
      # attach_function :ValidInstanceAddress, [], :void 
      # attach_function :Functions, [], :void 
      # attach_function :FindDefmessageHandler, [], :void 
      # attach_function :GetDefmessageHandlerList, [], :void 
      # attach_function :GetDefmessageHandlerName, [], :void 
      # attach_function :GetDefmessageHandlerPPForm, [], :void 
      # attach_function :GetDefmessageHandlerType, [], :void 
      # attach_function :GetDefmessageHandlerWatch, [], :void 
      # attach_function :GetNextDefmessageHandler, [], :void 
      # attach_function :IsDefmessageHandlerDeletable, [], :void 
      # attach_function :ListDefmessageHandlers, [], :void 
      # attach_function :PreviewSend, [], :void 
      # attach_function :SetDefmessageHandlerWatch, [], :void 
      # attach_function :UndefmessageHandler, [], :void 
    end
  end
end