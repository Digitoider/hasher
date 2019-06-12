# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class ArrayHandler < BaseHandler
        def to_h(node)
          return hasherize_array(node) if node.is_a?(Array)

          value = hasherize_array(node.value)

          key = preprocess_key(node.key)

          { key => value }
        end

        def can_hasherize?(node)
          node.is_a?(Array) || node.value.is_a?(Array)
        end

        private

        def hasherize_array(array)
          array.map { |n| main_hasherizer.to_h(n) }
        end

        def main_hasherizer
          @main_hasherizer ||= ::Kernel::Hasherizers::Dumpers::MainDumper.new
        end
      end
    end
  end
end
