# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Loaders
      class MainLoader
        def to_hasher(hash)
          loader = loaders.find { |l| l.can_load?(hash) }

          loader.to_hasher(hash)
        end

        private

        def loaders
          [
            ::Kernel::Hasherizers::Loaders::HashLoader.new,
            ::Kernel::Hasherizers::Loaders::ArrayLoader.new,
            ::Kernel::Hasherizers::Loaders::DefaultLoader.new
          ]
        end
      end
    end
  end
end
