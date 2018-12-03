# frozen_string_literal: true

module Kernel
  module Dirty
    class Indifferentiator
      def define(key)
        return key.to_s if stringify?(key)
        return key.to_sym if symbolize?(key)
        key
      end

      private

      def stringify?(key)
        (key.is_a?(Symbol) || key.is_a?(Numeric)) && !indifferent?(key)
      end

      def symbolize?(key)
        key.is_a?(String) && indifferent?(key)
      end

      def indifferent?(key)
        eval(":#{key}") == key.to_sym
      rescue Exception
        false
      end
    end
  end
end
