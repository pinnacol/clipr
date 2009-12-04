module Clips
  class Env
    class Deftemplates
      include Api::Deftemplate
      include Utils
      
      attr_reader :env
      attr_reader :casts
      attr_reader :pointers
      
      def initialize(env)
        @env = env
        @casts = {}
        @pointers = {}
      end
      
      def build(deftemplate)
        env.build_str(deftemplate.str)
        
        name = deftemplate.name
        ptr = env.find {|ptr| EnvFindDeftemplate(ptr, name) }
        
        casts[ptr.address] = deftemplate
        pointers[name.to_sym] = ptr
        
        ptr
      end
      
      def deftemplate(ptr)
        casts[ptr.address]
      end
      
      def ptr(name)
        pointers[name.to_sym] ||= begin
          ptr = env.find {|ptr| EnvFindDeftemplate(ptr, name.to_s) } 
          ptr or raise("no such deftemplate: #{name}")
        end
      end
      
      def list(options={})
        str = env.capture(options) do |ptr, logical_name, module_ptr|
          EnvListDeftemplates(ptr, logical_name, module_ptr)
        end
        
        parse_module_list(str)
      end
    end
  end
end