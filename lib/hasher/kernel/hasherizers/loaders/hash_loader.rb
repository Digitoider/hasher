# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Loaders
      class HashLoader
        def to_hasher(hash)
          hasher = Hasher.new
          hash.each do |key, value|
            hasher.method_missing(build_assigning(key), value)
          end
          hasher
        end

        def can_load?(elem)
          elem.is_a?(Hash)
        end

        private

        def build_assigning(key)
          "#{key}=".to_sym
        end
      end
    end
  end
end
