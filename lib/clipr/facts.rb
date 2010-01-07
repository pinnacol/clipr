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
      env_ptr = env.env_ptr
      deftemplate_ptr = env.deftemplates.ptr(deftemplate)
      fact_ptr = EnvCreateFact(env_ptr, deftemplate_ptr)
      
      data.each_pair do |slot, value|
        env.set(value) do |env_ptr, obj|
          EnvPutFactSlot(env_ptr, fact_ptr, slot.to_s, obj)
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
    # Fact.
    def [](index)
      cast get(index)
    end
    
    def each
      current = nil
      loop do
        current = get_next(current)
        break if current.nil?
        yield cast(current)
      end
      
      self
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
      str = env.capture do |env_ptr, logical_name, module_ptr|
        EnvFacts(env_ptr, logical_name, module_ptr, start_index, end_index, max)
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
      env.getptr {|env_ptr| EnvGetNextFact(env_ptr, current) }
    end
    
    def cast(fact_ptr) # :nodoc:
      template_ptr = env.getptr {|env_ptr| EnvFactDeftemplate(env_ptr, fact_ptr) }
      env.deftemplates.deftemplate(template_ptr).new(env, fact_ptr)
    end
  end
end