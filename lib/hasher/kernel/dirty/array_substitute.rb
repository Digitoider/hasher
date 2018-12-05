# frozen_string_literal: true

module Kernel
  class ArraySubstitute < Array
    attr_accessor :original_value_reference

    def <<(elem)
      resolve_push(elem)
    end

    def push(elem)
      resolve_push(elem)
    end

    private

    def resolve_push(elem)
      @original_value_reference << main_resolver.resolve(value: elem)
    end

    def main_resolver
      @main_resolver ||= ::Kernel::Resolvers::MainResolver.new
    end
  end
end
