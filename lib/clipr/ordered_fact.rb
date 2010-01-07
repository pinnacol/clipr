module Clipr
  class OrderedFact < Fact
    def initialize(env, fact_ptr)
      super
      @data = env.get {|env_ptr, obj| EnvGetFactSlot(env_ptr, fact_ptr, nil, obj) }.value
      @data.unshift(deftemplate.name.to_sym)
    end
    
    def slots
      (0..length).to_a
    end
    
    def [](index)
      @data[index]
    end
    
    def each_pair
      @data.each_with_index do |value, index|
        yield(index, value)
      end
    end
    
    def to_a
      @data.dup
    end
  end
end