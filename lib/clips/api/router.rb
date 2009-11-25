module Clips
  module Api
    # Router Documentation
    module Router
      extend FFI::Library
      ffi_lib DYLIB
      
      # router callbacks
      callback :queryFunction,  [:string], :int
      callback :printFunction,  [:string, :string], :int
      callback :getcFunction,   [:string], :int
      callback :ungetcFunction, [:int, :string], :int
      callback :exitFunction,   [:int], :int
      
      # attach_function :EnvActivateRouter, [:pointer], :void 
      attach_function :EnvAddRouter, [:pointer, :string, :int, :queryFunction, :printFunction, :getcFunction, :ungetcFunction, :exitFunction], :int 
      # attach_function :EnvDeactivateRouter, [:pointer], :void 
      attach_function :EnvDeleteRouter, [:pointer, :string], :int 
    end
  end
end