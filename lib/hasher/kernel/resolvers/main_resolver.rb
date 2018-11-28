# frozen_string_literal: true

module Kernel
  module Resolvers
    class MainResolver
      def resolve(key: nil, value:)
        found_resolver = resolvers.find do |resolver|
          resolver.can_resolve?(value)
        end

        found_resolver.resolve(key: key, value: value)
      end

      def resolvers
        @resolvers ||= [
          ::Kernel::Resolvers::BasicClassResolver.new,
          ::Kernel::Resolvers::ArrayResolver.new,
          ::Kernel::Resolvers::HashResolver.new,
          ::Kernel::Resolvers::DefaultResolver.new
        ]
      end
    end
  end
end
