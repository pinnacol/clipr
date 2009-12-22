module Clipr
  module Construct
    
    def intern(name, description=nil, &block)
      cls = Class.new(self)
      cls.instance_variable_set(:@name, name)
      cls.instance_variable_set(:@description, description)
      cls.instance_eval(&block)
      cls
    end
    
    def name
      @name ||= begin
        class_name = underscore(self.to_s)
        if class_name =~ /\A[a-z]\w*\z/
          class_name
        else
          "class_#{object_id}"
        end
      end
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