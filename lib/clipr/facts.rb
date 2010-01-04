module Clipr
  class Facts
    include Api::Fact
    include Utils
    include Enumerable
    
    attr_reader :env
    
    def initialize(env)
      @env = env
    end
    
    def assert(deftemplate, data={})
      env_ptr = env.pointer
      deftemplate_ptr = env.deftemplates.ptr(deftemplate)
      fact_ptr = EnvCreateFact(env_ptr, deftemplate_ptr)
      
      data.each_pair do |slot, value|
        env.set(value) do |ptr, obj|
          EnvPutFactSlot(ptr, fact_ptr, slot.to_s, obj)
        end
      end
      
      EnvAssignFactSlotDefaults(env_ptr, fact_ptr)
      EnvAssert(env_ptr, fact_ptr)
      self
    end
    
    # Returns a pointer to the specified fact.
    def get(index)
      current = get_next
      index.times { current = get_next(current) }
      current
    end
    
    # Returns the fact at the specified index, cast into an appropriate
    # Deftemplate.
    def [](index)
      cast get(index)
    end
    
    # Returns facts as an array, essentially by calling (facts) and parsing
    # the result.
    def list(options={})
      options = {
        :start => -1,
        :end => -1,
        :max => -1
      }.merge!(options)
      
      to_a(options[:start], options[:end], options[:max])
    end
    
    def to_a(start_index=-1, end_index=-1, max=-1)
      str = env.capture do |ptr, logical_name, module_ptr|
        EnvFacts(ptr, logical_name, module_ptr, start_index, end_index, max)
      end
      
      parse_fact_list(str)
    end
    
    def eql?(another)
      super || to_a.eql?(another)
    end
    
    def ==(another)
      super || to_a.eql?(another)
    end
    
    private
    
    def get_next(current=nil) # :nodoc:
      env.getptr {|ptr| EnvGetNextFact(ptr, current) }
    end
    
    def cast(fact_ptr) # :nodoc:
      template_ptr = env.getptr {|ptr| EnvFactDeftemplate(ptr, fact_ptr) }
      env.deftemplates.deftemplate(template_ptr).new(env, fact_ptr)
    end
  end
end