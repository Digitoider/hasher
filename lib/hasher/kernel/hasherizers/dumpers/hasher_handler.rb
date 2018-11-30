# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class HasherHandler
        def to_h(node)
          hash = hasher?(node) ? node.to_h : node.value.to_h
          hash = {} if empty?(hash)
          node.key.nil? ? hash : { node.key => hash }
        end

        def can_hasherize?(node)
          hasher?(node) || node.respond_to?(:value) && node.value.is_a?(::Hasher)
        end

        private

        def hasher?(node)
          node.is_a?(::Hasher)
        end

        def empty?(hash)
          hash == { nil => nil }
        end
      end
    end
  end
end
