require 'clips/defrule/actions'
require 'clips/defrule/conditions'

module Clips
  
  # class QuackRetract < Clips::Defrule
  #   lhs.assign :duck, "animal", :sound => :quack
  #   lhs.assign :cow,  "animal", :sound => :moo
  # 
  #   # pass all args in order
  #   rhs.call do |env, duck, cow|
  #     duck[:sound]          # => :quack
  #     cow[:sound]           # => :moo
  #   end
  # 
  #   # pass assigned args in given order
  #   rhs.call(:cow) do |env, cow|
  #     cow[:sound]           # => :moo
  #   end
  # 
  #   # assign all args into a hash
  #   rhs.call_hash do |env, argh|
  #     argh[:duck][:sound]   # => :quack
  #     argh[:cow][:sound]    # => :moo
  #   end
  # end
  #
  class Defrule
    class << self
      include Construct
      
      attr_reader :actions
      attr_reader :conditions
      
      def str
        desc = description.to_s.empty? ? " " : " \"#{description}\" "
        "(defrule #{name}#{desc}#{conditions.to_s} => #{actions.to_s})"
      end
      
      def call(env, data_objects)
        self.new.call(env, *data_objects)
      end
      
      protected
      
      def defrule(name)
        @name = name
      end
      
      def lhs(&block)
        conditions.instance_eval(&block) if block_given?
        conditions
      end
      
      def rhs(&block)
        actions.instance_eval(&block) if block_given?
        actions
      end
      
      private

      def inherited(base) # :nodoc:
        unless base.instance_variable_defined?(:@conditions)
          base.instance_variable_set(:@conditions, @conditions.dup)
        end
        
        unless base.instance_variable_defined?(:@actions)
          base.instance_variable_set(:@actions, @actions.dup)
        end
        
        super
      end
    end
    
    @actions = Actions.new
    @conditions = Conditions.new
    
    def call(env, args)
    end
  end
end