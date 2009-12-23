require 'ffi'
require 'clipr/api_error'
require 'clipr/constants'

Dir.glob("#{File.dirname(__FILE__)}/api/struct/*.rb").each do |struct_file|
  require struct_file
end

Dir.glob("#{File.dirname(__FILE__)}/api/*.rb").each do |api_file|
  require api_file
end

module Clipr
  
  # Api contains the {FFI}[http://github.com/ffi/ffi] bindings for the
  # embedded {CLIPS}[http://clipsrules.sourceforge.net/] API, organized into
  # modules as described in the Advanced Programming Guide (apg.pdf).  Only a
  # subset of the methods have been attached and the rest are left as stubs.
  # Stub methods are being attached as-needed by the Clipr project.
  #
  # Attaching a method consists of looking up the method signature in the apg
  # and translating it into the corresponding FFI signature (ex char => :char,
  # *type => :pointer).  There are, however, several details to be aware of.
  # Developers are encouraged to pay close attention this documentation, the
  # FFI documentation, and the apg when attaching new methods.
  #
  # === Companion Functions
  #
  # The apg describes most methods in a context-free form that routes the
  # calls through the 'current' Environment instance, normally set up through
  # InitializeEnvironment. However, if you try to attach a context-free method
  # you end up getting an FFI error like "Function 'Facts' not found".  This
  # error comes about because the context-free functions are defined as macros
  # in the CLIPS source code; they do not actually exist as documented.
  #
  # Instead they are all (with few exceptions) defined in a form that takes
  # the active Environment as a pointer -- these methods are prefixed by Env
  # (ex EnvFacts vs Facts).  Hence all of the stub methods take a pointer as
  # their first argument.
  #
  # This pattern is evidently maintained for callbacks as well.  For example
  # the Router.ungetc signature is [:pointer, :int, :string] rather than
  # [:int, :string], which is what you might guess when looking at the
  # documentation.  The Proc or Method corresponding to the callback must
  # likewise accept this pointer.  In Router the ungetc method looks like
  # this:
  #
  #   def ungetc(ptr, c, name)
  #     ...
  #   end
  #
  # The Environment may or may not be relevant in a given callback.  In the
  # example it is not, and ungetc simply ignores the input.  See the
  # 'Environment Companion Function' discussion in the apg for more details.
  #
  # === Best Practices
  #
  # In general the CLIPS API uses integer returns to signify success or
  # failure.  For these API calls it's typical to check the return value and
  # raise an ApiError if the script should not continue.  For example:
  #
  #   # Excerpt from Clipr::Env#close
  #   def close
  #     unless DestroyEnvironment(@pointer)
  #       raise ApiError(:Environment, :DestroyEnvironment, "could not close environment")
  #     end
  #     ...
  #   end
  #
  # For some API failures the CLIPS error messages are meaningful.  Use the
  # Env#capture method or re-route the relevant output device for the duration
  # of the call.  For example:
  #
  #   # Excerpt from Clipr::Env#build
  #   def build(str)
  #     router.capture('werror') do |device|
  #       if EnvBuild(pointer, str) == 0
  #         msg = device.string
  #         msg = "could not build: #{str}" if msg.empty?
  #         raise ApiError.new(:Environment, :EnvBuild, msg)
  #       end
  #     end
  #     ...
  #   end
  #
  # Numerous examples and variations of this method can be found by digging
  # around in the code.
  module Api
    extend FFI::Library
    ffi_lib DYLIB
    
    EXACTLY      = 0
    AT_LEAST     = 1
    NO_MORE_THAN = 2
    
    FLOAT            = 0
    INTEGER          = 1
    SYMBOL           = 2
    STRING           = 3
    MULTIFIELD       = 4
    EXTERNAL_ADDRESS = 5
    FACT_ADDRESS     = 6
    INSTANCE_ADDRESS = 7
    INSTANCE_NAME    = 8
    
    CAST = {
      FLOAT => Struct::FloatHashNode,
      INTEGER => Struct::IntegerHashNode,
      SYMBOL => Struct::SymbolHashNode,
      STRING => Struct::SymbolHashNode
    }
    
    callback :callback, [], :int
    attach_function :DefineFunction,[:string, :char, :callback, :string], :int
    attach_function :DefineFunction2, [:string, :char, :callback, :string, :string], :int
    
    callback :env_callback, [:pointer], :int
    attach_function :EnvDefineFunction, [:pointer, :string, :char, :env_callback, :string], :int
    attach_function :EnvDefineFunction2, [:pointer, :string, :char, :env_callback, :string, :string], :int
    
    attach_function :EnvRtnArgCount, [:pointer], :int
    attach_function :EnvArgCountCheck, [:pointer, :string, :int, :int], :int
    attach_function :EnvRtnUnknown, [:pointer, :int, :pointer], :pointer
  end
end