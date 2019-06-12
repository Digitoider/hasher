# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Loaders
      class DefaultLoader
        def to_hasher(elem)
          elem
        end

        def can_load?(_elem)
          true
        end
      end
    end
  end
end
