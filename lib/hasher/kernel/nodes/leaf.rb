# frozen_string_literal: true

module Kernel
  module Nodes
    class Leaf < Base
      def leaf?
        true
      end

      def composite?
        false
      end

      def value=(node)
        @value = node.value
      end

      def value
        return array_substitute if @value.is_a?(Array)
        @value
      end

      private

      def array_substitute
        return_value = @value.map do |elem|
          elem.is_a?(Base) ? elem.value : elem
        end

        return_value = ::Kernel::ArraySubstitute.new(return_value)
        return_value.original_value_reference = @value
        return_value
      end
    end
  end
end
