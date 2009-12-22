module Clipr
  class Defglobals
    include Api::Defglobal
    include Utils
    
    attr_reader :env
    
    def initialize(env)
      @env = env
    end
    
    def get(name)
      env.get do |ptr, obj|
        if EnvGetDefglobalValue(ptr, name, obj) == 0
          return nil
        end
      end
    end
    
    def set(name, value)
      env.build("(defglobal ?*#{name}* = 0)")
      
      env.set(value) do |ptr, obj|
        if EnvSetDefglobalValue(ptr, name, obj) == 0
          raise ApiError.new(:Defglobal, :EnvSetDefglobalValue, "cannot set: #{name} (global does not exist)")
        end
      end
    end
    
    def list(options={})
      str = env.capture(options) do |ptr, logical_name, module_ptr|
        EnvListDefglobals(ptr, logical_name, module_ptr)
      end
      
      list = {}
      parse_module_list(str).each_pair do |module_name, names|
        values = {}
        names.each do |name|
          values[name] = get(name).value
        end
        
        list[module_name] = values
      end
      
      list
    end
  end
end