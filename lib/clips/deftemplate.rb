require 'clips/construct'
require 'clips/deftemplate/slot'

module Clips
  class Deftemplate
    class << self
      include Construct
      
      attr_reader :slots
      
      def str
        slot_defs = slots.values.collect {|slot| slot.to_s }
        "(deftemplate #{name} \"#{description}\" #{slot_defs.join(' ')})"
      end
      
      protected
      
      def deftemplate(name)
        @name = name
      end
      
      def slot(name, default=nil, options={})
        slots[name] = Slot.new(name, default, options)
      end
    
      def multislot(name, default=[], options={})
        slots[name] = Slot.new(name, default, options, true)
      end
      
      def remove(name)
        unless slots.has_name?(name)
          raise NameError.new("not a slot on #{self}: #{name.inspect}")
        end
        slots.delete(name)
      end

      def undefine(name)
        unless values.has_name?(name)
          raise NameError.new("not defined on #{self}: #{name.inspect}")
        end
        slots[name] = nil
      end
      
      private

      def inherited(base)
        unless base.instance_variable_defined?(:@slots)
          base.instance_variable_set(:@slots, {})
        end
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
    
    attr_reader :data_object
    
    def initialize(data_object)
      @data_object = data_object
    end
  end
end