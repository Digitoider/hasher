# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Loaders
      class ArrayLoader
        def to_hasher(array)
          array.map do |elem|
            main_dumper.to_hasher(elem)
          end
        end

        def can_load?(elem)
          elem.is_a?(Array)
        end
      end
    end
  end
end
