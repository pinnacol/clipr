require 'clips/construct'
require 'clips/fact/slot'

module Clips
  class Fact
    module Api
      include Construct
      
      attr_reader :slots
      
      def self.initialize(base)
        unless base.instance_variable_defined?(:@slots)
          base.instance_variable_set(:@slots, {})
        end
        
        base.reset
      end
      
      def name
        self.to_s.gsub("::", "_")
      end
      
      def content
        @content ||= begin
          slot_defs = slots.values.collect {|slot| slot.to_s }
          "(deftemplate #{name} #{slot_defs.join(' ')})"
        end
      end
      
      protected
      
      def slot(name, default=nil, options={})
        slots[name] = Slot.new(name, default, options)
        reset
      end
    
      def multislot(name, default=[], options={})
        slots[name] = Slot.new(name, default, options, true)
        reset
      end
      
      def remove(name)
        unless slots.has_name?(name)
          raise NameError.new("not a slot on #{self}: #{name.inspect}")
        end
        slots.delete(name)
        reset
      end

      def undefine(name)
        unless values.has_name?(name)
          raise NameError.new("not defined on #{self}: #{name.inspect}")
        end
        slots[name] = nil
        reset
      end
      
      private

      def inherited(base)
        Api.initialize(base)
        super
      end

      def each_ancestor
        yield(self)

        blank, *ancestors = self.ancestors
        ancestors.each do |ancestor|
          yield(ancestor) if ancestor.kind_of?(ClassMethods)
        end

        nil
      end
    end
    
    extend Api
  end
end