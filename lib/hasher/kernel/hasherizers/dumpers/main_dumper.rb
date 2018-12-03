# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class MainDumper
        def to_h(node)
          hasherizer = handlers.find do |handler|
            handler.can_hasherize?(node)
          end

          hasherizer.to_h(node)
        end

        protected

        def handlers
          @handlers ||= [
            ::Kernel::Hasherizers::Dumpers::BasicTypeHandler.new,
            ::Kernel::Hasherizers::Dumpers::CompositeNodeHandler.new,
            ::Kernel::Hasherizers::Dumpers::KeyValuePairNilHandler.new,
            ::Kernel::Hasherizers::Dumpers::ArrayHandler.new,
            ::Kernel::Hasherizers::Dumpers::HasherHandler.new,
            ::Kernel::Hasherizers::Dumpers::IntegerHandler.new,
            ::Kernel::Hasherizers::Dumpers::DefaultHandler.new
          ]
        end
      end
    end
  end
end
