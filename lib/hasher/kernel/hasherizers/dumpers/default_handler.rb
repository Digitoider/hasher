# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class DefaultHandler
        def to_h(node)
          { node.key => node.value }
        end

        def can_hasherize?(_node)
          true
        end
      end
    end
  end
end
