# frozen_string_literal: true

module Kernel
  module Resolvers
    class BasicClassResolver < BaseResolver
      BASIC_TYPES = [
        String, Numeric, Integer, Symbol, TrueClass, FalseClass, NilClass
      ].freeze

      def resolve(key: nil, value:)
        ::Kernel::Nodes::Leaf.new(key: key, value: value)
      end

      def can_resolve?(value)
        BASIC_TYPES.include?(value.class)
      end
    end
  end
end
