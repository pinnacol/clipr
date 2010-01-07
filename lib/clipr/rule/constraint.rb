module Clipr
  class Rule
    class Constraint
      attr_accessor :slot
      attr_accessor :terms
      attr_accessor :predicate
      
      def initialize(slot, terms=[], &predicate)
        @slot = slot
        @terms = terms
        @predicate = predicate
      end
      
      def call(env, data_objects)
        data_objects.collect! {|obj| env.cast(obj) }
        predicate.call(*data_objects)
      end
      
      def to_s
        cross_terms = terms.inject([[]]) do |current, term|
          cross_product(current, term)
        end
        
        if predicate
          predicate_term = ":(ruby-call #{object_id} ?v#{object_id})"
          cross_terms.each {|term| term << predicate_term }
        end
        
        condition = cross_terms.collect do |term|
          term.join("&")
        end.join("|")
        
        if predicate
          condition = "?v#{object_id}&#{condition}"
        end
        
        "(#{slot} #{condition})"
      end
      
      protected
      
      def cross_product(a, b) # :nodoc:
        if b.kind_of?(Array)
          products = []
          a.each do |aa|
            b.each do |bb|
              product = aa.dup
              product  << bb
              products << product
            end
          end
          products
        else
          a.each {|aa| aa << b }
        end
      end
    end
  end
end