module Clips
  module Api
    # Deffunction Documentation
    module Deffunction
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :DeffunctionModule, [], :void 
      # attach_function :FindDeffunction, [], :void 
      # attach_function :GetDeffunctionList, [], :void 
      # attach_function :GetDeffunctionName, [], :void 
      # attach_function :GetDeffunctionPPForm, [], :void 
      # attach_function :GetDeffunctionWatch, [], :void 
      # attach_function :GetNextDeffunction, [], :void 
      # attach_function :IsDeffunctionDeletable, [], :void 
      # attach_function :ListDeffunctions, [], :void 
      # attach_function :SetDeffunctionWatch, [], :void 
      # attach_function :Undeffunction, [], :void 
    end
  end
end