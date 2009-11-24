module Clips
  module Api
    # Deffacts Documentation
    module Deffacts
      extend FFI::Library
      ffi_lib DYLIB
      
      # attach_function :DeffactsModule, [], :void 
      # attach_function :FindDeffacts, [], :void 
      # attach_function :GetDeffactsList, [], :void 
      # attach_function :GetDeffactsName, [], :void 
      # attach_function :GetDeffactsPPForm, [], :void 
      # attach_function :GetNextDeffacts, [], :void 
      # attach_function :IsDeffactsDeletable, [], :void 
      # attach_function :ListDeffacts, [], :void 
      # attach_function :Undeffacts, [], :void 
    end
  end
end