module Clips
  class Env
    module Utils
      module_function
      
      def parse_module_list(str)
        modules = {}
        current = nil
        
        lines = str.split(/\n\s*/)
        lines.pop # "For a total of n xyz."
        
        lines.each do |line|
          if line =~ /\A(.*):\z/
            current = []
            modules[$1] = current
          else
            current << line
          end
        end
        
        modules
      end
    end
  end
end