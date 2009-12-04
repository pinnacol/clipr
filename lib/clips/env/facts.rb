module Clips
  class Env
    class Facts
      include Api
      include Utils
      
      attr_reader :env
      
      def initialize(env)
        @env = env
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
          Fact::EnvFacts(ptr, logical_name, module_ptr, options[:start], options[:end], options[:max])
        end
        
        parse_fact_list(str)
      end
    end
  end
end