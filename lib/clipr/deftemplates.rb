require 'clipr/deftemplates/ordered_fact'

module Clipr
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
    
    def clear
      @casts.clear
      @pointers.clear
    end
    
    def build(deftemplate)
      env.build(deftemplate)
      
      name = deftemplate.name
      ptr = env.getptr {|env_ptr| EnvFindDeftemplate(env_ptr, name) }
      
      casts[ptr.address] = deftemplate
      pointers[name.to_sym] = ptr
      
      ptr
    end
    
    def deftemplate(template_ptr)
      casts[template_ptr.address] || (implied?(template_ptr) ? OrderedFact : Fact)
    end
    
    def ptr(name)
      pointers[name.to_sym] ||= begin
        template_ptr = env.getptr {|env_ptr| EnvFindDeftemplate(env_ptr, name.to_s) } 
        template_ptr or raise("no such deftemplate: #{name}")
      end
    end
    
    def list(options={})
      str = env.capture(options) do |env_ptr, logical_name, module_ptr|
        EnvListDeftemplates(env_ptr, logical_name, module_ptr)
      end
      
      parse_module_list(str)
    end
    
    private
    
    # Determines if the template_ptr points to an implied deftemplate by
    # checking that the slot names are [:implied]
    def implied?(template_ptr) # :nodoc:
      slot_names = env.get {|env_ptr, obj| EnvDeftemplateSlotNames(env_ptr, template_ptr, obj) }
      slot_names.type == Api::Types::MULTIFIELD && slot_names.value == [:implied]
    end
  end
end