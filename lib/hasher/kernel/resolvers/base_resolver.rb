# frozen_string_literal: true

module Kernel
  module Resolvers
    class BaseResolver
      def resolve(_key, _value)
        raise ::Kernel::Errors::NotImpementedError.new(:resolve)
      end

      def can_resolve?(_value)
        raise ::Kernel::Errors::NotImpementedError.new(:can_resolve?)
      end
    end
  end
end
