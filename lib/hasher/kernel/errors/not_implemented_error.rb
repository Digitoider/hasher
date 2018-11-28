# frozen_string_literal: true

module Kernel
  module Errors
    class NotImpementedError < StandardError
      def initialize(method_name)
        message = "`#{method_name}` is not implemented."
        super(message)
      end
    end
  end
end
