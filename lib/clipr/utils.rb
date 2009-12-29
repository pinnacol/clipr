module Clipr
  module Utils
    module_function
    
    def split(str)
      lines = str.split(/\n\s*/)
      lines.pop # "For a total of n xyz."
      lines
    end
    
    def parse_module_list(str)
      modules = {}
      current = nil
      split(str).each do |line|
        if line =~ /\A(.*):\z/
          current = []
          modules[$1] = current
        else
          current << line
        end
      end
      
      modules
    end
    
    def parse_fact_list(str)
      facts = []
      split(str).each do |line|
        unless line =~ /\Af-\d+\s+(.*)\z/
          raise "unknown fact format: #{line}"
        end
        
        facts << $1
      end
      
      facts
    end
    
    def value_str(value)
      case value
      when Symbol, Integer, Float
        value.to_s
      when String
        "\"#{value}\""
      else
        non_primitive_value_str(value)
      end
    end
    
    def non_primitive_value_str(value)
      raise "non-primitive values are not supported yet!"
    end
  end
end