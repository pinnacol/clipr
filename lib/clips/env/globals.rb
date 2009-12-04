module Clips
  class Env
    class Globals
      include Api
      include Utils
      
      attr_reader :env
      
      def initialize(env)
        @env = env
      end
      
      def get(name)
        env.get do |ptr, obj|
          if Defglobal::EnvGetDefglobalValue(ptr, name, obj) == 0
            return nil
          end
        end
      end
      
      def set(name, value)
        env.build_str("(defglobal ?*#{name}* = 0)")
        env.set(value) do |ptr, obj|
          Defglobal::EnvSetDefglobalValue(ptr, name, obj)
        end
      end
      
      def list(module_name=nil)
        listing = env.capture(module_name) do |ptr, logical_name, module_ptr|
          Defglobal.EnvListDefglobals(ptr, logical_name, module_ptr)
        end
        
        list = {}
        parse_module_list(listing).each_pair do |module_name, names|
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
end