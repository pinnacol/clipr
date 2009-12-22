module Clipr
  class ApiError < StandardError
    def initialize(mod, method_name, msg)
      super(msg)
    end
  end
end