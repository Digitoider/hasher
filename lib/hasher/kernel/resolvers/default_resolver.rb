# frozen_string_literal: true

module Kernel
  module Resolvers
    class DefaultResolver < BaseResolver
      def resolve(key: nil, value:)
        ::Kernel::Nodes::Leaf.new(key: key, value: value)
      end

      def can_resolve?(_value)
        true
      end
    end
  end
end
