# frozen_string_literal: true

module Kernel
  module Resolvers
    class ArrayResolver < BaseResolver
      def resolve(key: nil, value:)
        main_resolver = ::Kernel::Resolvers::MainResolver.new
        nodes = value.map do |elem|
          main_resolver.resolve(key: key, value: elem)
        end

        ::Kernel::Nodes::Leaf.new(key: key, value: nodes)
      end

      def can_resolve?(value)
        value.is_a?(Array)
      end
    end
  end
end
