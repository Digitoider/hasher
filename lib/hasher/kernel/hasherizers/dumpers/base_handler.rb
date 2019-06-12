# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class BaseHandler
        def to_h(_node)
          raise ::Kernel::Errors::NotImpementedError.new(:to_h)
        end

        def can_hasherize?(_node)
          raise ::Kernel::Errors::NotImpementedError.new(:can_hasherize?)
        end

        protected

        def preprocess_key(key)
          return key.to_i if integer?(key)
          return key.to_f if float?(key)
          key
        end

        def node?(node)
          node.is_a?(::Kernel::Nodes::Base)
        end

        private

        def integer?(key)
          /^[-+]?\d+$/.match?(key.to_s)
        end

        def float?(key)
          /^[-]?\d+\.\d+$/.match?(key.to_s)
        end
      end
    end
  end
end
