module Clipr
  module Api
    # Router Documentation
    module Router
      extend FFI::Library
      ffi_lib DYLIB
      
      # router callbacks
      callback :queryFunction,  [:pointer, :string], :int
      callback :printFunction,  [:pointer, :string, :string], :int
      callback :getcFunction,   [:pointer, :string], :int
      callback :ungetcFunction, [:pointer, :int, :string], :int
      callback :exitFunction,   [:pointer, :int], :int
      
      # attach_function :EnvActivateRouter, [:pointer], :void 
      attach_function :EnvAddRouter, [:pointer, :string, :int, :queryFunction, :printFunction, :getcFunction, :ungetcFunction, :exitFunction], :int 
      # attach_function :EnvDeactivateRouter, [:pointer], :void 
      attach_function :EnvDeleteRouter, [:pointer, :string], :int 
    end
  end
end