# frozen_string_literal: true

module Kernel
  module Nodes
    class Base
      attr_reader :value, :key

      def initialize(key: nil, value: nil)
        @key = key
        @value = value
      end

      def leaf?
        raise ::Kernel::Errors::NotImpementedError.new(:leaf?)
      end

      def composite?
        raise ::Kernel::Errors::NotImpementedError.new(:composite?)
      end
    end
  end
end
