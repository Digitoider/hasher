# frozen_string_literal: true

module Kernel
  class Hasherizer
    def to_h(node)
      ::Kernel::Hasherizers::Dumpers::MainDumper.new.to_h(node)
    end

    def to_hasher(hash)
      # TODO: deep symbolize hash
      ::Kernel::Hasherizers::Loaders::MainLoader.new.to_hasher(hash)
    end
  end
end
