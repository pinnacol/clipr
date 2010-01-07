require 'clipr/fact/slot'

module Clipr
  class Fact
    class << self
      include Construct
      
      attr_reader :slots
      
      def construct_str
        slot_defs = slots.values.collect {|slot| slot.to_s }
        desc = description.empty? ? description : " \"#{description}\""
        "(deftemplate #{name}#{desc} #{slot_defs.join(' ')})"
      end
      
      protected
      
      def deftemplate(name)
        @name = name
      end
      
      def slot(name, default=nil, options={})
        slots[name] = Slot.new(name, default, options)
      end
      
      # def multislot(name, default=[], options={})
      #   slots[name] = Slot.new(name, default, options, true)
      # end
      
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
    end
    
    include Api::Fact
    
    attr_reader :env
    attr_reader :fact_ptr
    
    def initialize(env, fact_ptr)
      @env = env
      @fact_ptr = fact_ptr
    end
    
    def template_ptr
      env.getptr {|env_ptr| EnvFactDeftemplate(env_ptr, fact_ptr) }
    end
    
    def name
      Api::GetConstructNameString(template_ptr)
    end
    
    def slots
      env.get {|env_ptr, obj| EnvFactSlotNames(env_ptr, fact_ptr, obj) }.value
    end
    
    def get(slot)
      env.get {|env_ptr, obj| EnvGetFactSlot(env_ptr, fact_ptr, slot.to_s, obj) }
    end
    
    def [](slot)
      get(slot).value
    end
    
    def each_pair
      slots.each do |slot|
        yield(slot, self[slot])
      end
    end
  end
end