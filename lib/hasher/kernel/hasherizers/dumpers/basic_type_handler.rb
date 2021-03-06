# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class BasicTypeHandler < BaseHandler
        def to_h(node)
          node
        end

        def can_hasherize?(node)
          denied_types.none? { |type| node.is_a?(type) }
        end

        private

        def denied_types
          [
            ::Hasher,
            ::Kernel::Nodes::Base,
            Array
          ]
        end
      end
    end
  end
end
