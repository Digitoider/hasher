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
        return @value unless @value.is_a?(Array)

        @value.map do |elem|
          elem.is_a?(Base) ? elem.value : elem
        end
      end
    end
  end
end
