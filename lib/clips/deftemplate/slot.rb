module Clips
  class Deftemplate
    # Indicates no default when used in a slot definition.
    OPTIONAL = nil
    
    # Indicates (default ?DERIVE) when used in a slot definition.
    DERIVE = Object.new

    # Indicates (default ?NONE) when used in a slot definition.
    NONE = Object.new
    
    class Slot
      include Utils
      
      attr_reader :name
      attr_reader :default
      attr_reader :options
      
      def initialize(name, default=OPTIONAL, options={})
        @name = name
        @default = default
        @options = options
      end
      
      def types
        options[:types]
      end
      
      def allows
        options[:allows] || {}
      end
      
      def dynamic_default?
        options[:dynamic_default]
      end
      
      def multislot?
        options[:multislot]
      end
      
      def to_s
        "(#{slot_type} #{name}#{format_constraints(options)}#{format_default(default)})"
      end
      
      private
      
      def slot_type # :nodoc:
        multislot? ? 'multislot' : 'slot'
      end
      
      def default_type # :nodoc:
        dynamic_default? ? 'dynamic-default' : 'default'
      end
      
      def format_default(default) # :nodoc:
        case default
        when OPTIONAL then ""
        when NONE     then " (#{default_type} ?NONE)"
        when DERIVE   then " (#{default_type} ?DERIVE)"
        else " (#{default_type} #{value_str(default)})"
        end
      end
      
      def format_constraints(options) # :nodoc:
        constraints = [nil]
        constraints << "(type #{types.join(' ')})" if types
        
        allows.each_pair do |type, values|
          type = type.to_s.downcase
          constraints << "(allowed-#{type} #{values.join(' ')})"
        end
        
        constraints.join(' ')
      end
      
      def non_primitive_value_str(value) # :nodoc:
        raise "non-primitive default values are not supported yet: #{value.inspect}"
      end
    end
  end
end