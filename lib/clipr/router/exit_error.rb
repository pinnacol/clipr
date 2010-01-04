module Clipr
  class Router
    class ExitError < StandardError
      attr_reader :code
      def initialize(code)
        @code = code
        super "router exit: #{code}"
      end
    end
  end
end