module Clips
  class Defrule
    class Constraint
      attr_reader :slot
      attr_reader :terms
      attr_reader :predicate
      
      def initialize(slot, terms=[], &predicate)
        @slot = slot
        @terms = terms
        @predicate = predicate
      end
      
      def to_s
        cross_terms = terms.inject([[]]) do |current, term|
          cross_product(current, term)
        end
        
        if predicate
          oid = predicate.object_id
          predicate_term = ":(ruby-call #{oid} ?v#{oid})"
          cross_terms.each {|term| term << predicate_term }
        end
        
        condition = cross_terms.collect do |term|
          term.join("&")
        end.join("|")
        
        if predicate
          condition = "?v#{oid}&#{condition}"
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