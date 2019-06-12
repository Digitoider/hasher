# frozen_string_literal: true

module Kernel
  class ActionResolver
    def resolve(key, value, tree)
      return resolve_assigning(key, value, tree) if assigning?(key)
      resolve_retrieval(key, tree)
    end

    def resolve_assigning(key, value, tree)
      extracted_key = extract_key(key)
      extracted_key = indifferentiator.define(extracted_key)
      tree.assign(extracted_key, value)
      ::Kernel::Response.new(assigned: true)
    end

    def resolve_retrieval(key, tree)
      key = indifferentiator.define(key)
      value = tree.retrieve(key)
      ::Kernel::Response.new(retrieved: true, value: value)
    end

    protected

    def simple?(key)
      key.is_a?(String) || key.is_a?(Symbol)
    end

    def assigning?(key)
      simple?(key) && key.to_s.chars.last == Operations::VALUE_ASSIGNING
    end

    def retrieval?(key)
      !assigning?(key)
    end

    def extract_key(key)
      return key if retrieval?(key)

      extracted_key = key.to_s[0...-1]
      key.is_a?(String) ? extracted_key : extracted_key.to_sym
    end

    def indifferentiator
      @indifferentiator ||= ::Kernel::Dirty::Indifferentiator.new
    end
  end
end
