# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class ArrayHandler < BaseHandler
        def to_h(node)
          result = node.value.map do |n|
            main_hasherizer.to_h(n)
          end

          key = preprocess_key(node.key)

          { key => result }
        end

        def can_hasherize?(node)
          node.value.is_a?(Array)
        end

        private

        def main_hasherizer
          @main_hasherizer ||= ::Kernel::Hasherizers::Dumpers::MainDumper.new
        end
      end
    end
  end
end
