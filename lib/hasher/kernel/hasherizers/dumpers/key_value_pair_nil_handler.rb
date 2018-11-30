# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class KeyValuePairNilHandler
        def to_h(_node)
          {}
        end

        def can_hasherize?(node)
          node.is_a?(::Kernel::Nodes::Base) && node.key.nil? && node.value.nil?
        end
      end
    end
  end
end
