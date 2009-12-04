module Clips
  class Env
    class Facts
      include Api::Fact
      include Utils
      
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
      
      # Returns facts as an array, essentially by calling (facts) and parsing
      # the result.
      def list(options={})
        options = {
          :start => -1,
          :end => -1,
          :max => -1
        }.merge!(options)

        str = env.capture(options) do |ptr, logical_name, module_ptr|
          EnvFacts(ptr, logical_name, module_ptr, options[:start], options[:end], options[:max])
        end
        
        parse_fact_list(str)
      end
    end
  end
end