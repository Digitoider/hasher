# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class DefaultHandler < BaseHandler
        def to_h(node)
          key = preprocess_key(node.key)
          { key => node.value }
        end

        def can_hasherize?(_node)
          true
        end
      end
    end
  end
end
