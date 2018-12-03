# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class HasherHandler < BaseHandler
        def to_h(node)
          hash = hasher?(node) ? node.to_h : node.value.to_h
          key = preprocess_key(node.key)
          node.key.nil? ? hash : { key => hash }
        end

        def can_hasherize?(node)
          hasher?(node) || node.respond_to?(:value) && hasher?(node.value)
        end

        private

        def hasher?(node)
          node.is_a?(::Hasher)
        end
      end
    end
  end
end
