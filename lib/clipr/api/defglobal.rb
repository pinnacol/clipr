module Clipr
  module Api
    # Defglobal Documentation
    module Defglobal
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :EnvDefglobalModule, [:pointer], :void 
      attach_function :EnvFindDefglobal, [:pointer, :string], :pointer 
      # attach_function :EnvGetDefglobalList, [:pointer], :void 
      # attach_function :EnvGetDefglobalName, [:pointer], :void 
      # attach_function :EnvGetDefglobalPPForm, [:pointer], :void 
      attach_function :EnvGetDefglobalValue, [:pointer, :string, :pointer], :int 
      # attach_function :EnvGetDefglobalValueForm, [:pointer], :void 
      # attach_function :EnvGetDefglobalWatch, [:pointer], :void 
      # attach_function :EnvGetGlobalsChanged, [:pointer], :void 
      # attach_function :EnvGetNextDefglobal, [:pointer], :void 
      # attach_function :EnvGetResetGlobals, [:pointer], :void 
      # attach_function :EnvIsDefglobalDeletable, [:pointer], :void 
      attach_function :EnvListDefglobals, [:pointer, :string, :pointer], :void 
      attach_function :EnvSetDefglobalValue, [:pointer, :string, :pointer], :int 
      # attach_function :EnvSetDefglobalWatch, [:pointer], :void 
      # attach_function :EnvSetGlobalsChanged, [:pointer], :void 
      # attach_function :EnvSetResetGlobals, [:pointer], :void 
      # attach_function :EnvShowDefglobals, [:pointer], :void 
      # attach_function :EnvUndefglobal, [:pointer], :void 
    end
  end
end