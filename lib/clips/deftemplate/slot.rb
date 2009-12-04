module Clips
  class Deftemplate
    # Indicates (default ?DERIVE) when used in a slot definition.
    DERIVE = Object.new

    # Indicates (default ?NONE) when used in a slot definition.
    NONE = nil
    
    class Slot
      
      attr_reader :name
      attr_reader :default
      attr_reader :options
      
      def initialize(name, default, options={}, multislot=false)
        @name = name
        @default = default
        @options = options
        @multislot = multislot
      end
      
      def multislot?
        @multislot
      end
      
      def to_s
        format = multislot? ? '(multislot %s %s %s)' : '(slot %s %s %s)'
        format % [name, format_constraints(options), format_default(default)]
      end
      
      protected
      
      def format_default(default) # :nodoc:
        case default
        when NONE   then "(default ?NONE)"
        when DERIVE then "(default ?DERIVE)"
        else "(default #{default})"
        end
      end
      
      def format_constraints(options) # :nodoc:
        constraints = []
        
        if types = options[:types]
          constraints << "(type #{types.join(' ')})"
        end
        
        if allowed = options[:allowed]
          allowed.each_pair do |type, values|
            constraints << "(allowed-#{type.downcase} #{values.join(' ')})"
          end
        end
        
        constraints.join(' ')
      end
    end
  end
end