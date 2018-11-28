# frozen_string_literal: true

module Kernel
  class ActionResolver
    def resolve(key, args, tree)
      return resolve_retrieval(key, tree) if retrieval?(key)

      extracted_key = extract_key(key)
      value = args.first
      resolve_assigning(extracted_key, value, tree)
    end

    protected

    def assigning?(key)
      key.to_s.chars.last == Operations::VALUE_ASSIGNING
    end

    def retrieval?(key)
      !assigning?(key)
    end

    def resolve_assigning(extracted_key, value, tree)
      tree.assign(extracted_key, value)
      ::Kernel::Response.new(assigned: true)
    end

    def resolve_retrieval(key, tree)
      # binding.pry
      value = tree.retrieve(key)
      ::Kernel::Response.new(retrieved: true, value: value)
    end

    def extract_key(key)
      extracted_key = key.to_s.split(Operations::VALUE_ASSIGNING).first
      extracted_key.to_sym
    end
  end
end
