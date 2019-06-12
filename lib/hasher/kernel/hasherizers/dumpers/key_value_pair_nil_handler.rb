# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class KeyValuePairNilHandler < BaseHandler
        def to_h(_node)
          {}
        end

        def can_hasherize?(node)
          node?(node) && node.key.nil? && node.value.nil?
        end
      end
    end
  end
end
