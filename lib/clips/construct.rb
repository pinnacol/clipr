module Clips
  module Construct
    
    def name
      @name ||= underscore(self.to_s)
    end
    
    def description
      @description ||= ""
    end
    
    protected
    
    def desc(description)
      @description = description
    end
    
    private
    
    # The reverse of camelize. Makes an underscored, lowercase form 
    # from self.  underscore will also change '::' to '/' to convert 
    # namespaces to paths.
    def underscore(str)
      str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end