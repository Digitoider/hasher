# frozen_string_literal: true

module Kernel
  class Hasherizer
    def to_h(node)
      ::Kernel::Hasherizers::Dumpers::MainDumper.new.to_h(node)
    end
  end
end
