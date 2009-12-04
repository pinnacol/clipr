module Clips
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
        unless line =~ /\Af-(\d+)\s+(.*)\z/
          raise "unknown fact format: #{line}"
        end
        
        facts[$1.to_i] = $2
      end
      
      facts
    end
  end
end