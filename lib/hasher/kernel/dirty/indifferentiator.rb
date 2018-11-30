# frozen_string_literal: true

module Kernel
  module Dirty
    class Indifferentiator
      def define(key)
        return key.to_s if key.is_a?(Symbol) && !indifferent?(key)
        return key.to_sym if key.is_a?(String) && indifferent?(key)
        key
      end

      private

      def indifferent?(key)
        eval(":#{key}") == key.to_sym
      rescue Exception
        false
      end
    end
  end
end
