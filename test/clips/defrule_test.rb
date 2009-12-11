require File.dirname(__FILE__) + "/../test_helper"
require "clips"

class DefruleTest < Test::Unit::TestCase
  Defrule = Clips::Defrule
  
  def test_defrule_formats_simple_rules_to_call_back_to_class
    rule = Defrule.intern "basic" do
      lhs.match 'sample', :key => :value
      rhs.register(self)
    end
    
    assert_equal Class, rule.class
    assert_equal Defrule, rule.superclass
    assert_equal "(defrule basic (sample (key value)) => (ruby-call #{rule.object_id}))", rule.str
  end
end