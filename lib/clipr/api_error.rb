module Clipr
  class ApiError < StandardError
    def initialize(mod, method_name, msg)
      if msg.empty? && block_given?
        msg = yield 
      end

      super(msg)
    end
  end
end