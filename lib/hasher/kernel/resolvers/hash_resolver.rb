# frozen_string_literal: true

module Kernel
  module Resolvers
    class HashResolver < BaseResolver
      def resolve(key: nil, value:)
        hasher = ::Hasher.new

        value.each { |k, v| hasher.send(create_assiging(k), v) }

        ::Kernel::Nodes::Leaf.new(key: key, value: hasher)
      end

      def can_resolve?(value)
        value.is_a?(Hash)
      end

      protected

      def create_assiging(name)
        "#{name}=".to_sym
      end
    end
  end
end
