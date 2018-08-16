# frozen_string_literal: true

module Kernel
  class Resolver
    def initialize

    end

    def resolve(key, args)
      operation = key.to_s.chars.last
      extracted_key = extract_key(key)
      value = args.first
      # binding.pry
      add_chain_link(extracted_key)
      return resolve_assigning(value)  if operation == Operations::VALUE_ASSIGNING
      resolve_retrieval(extracted_key) if operation == Operations::VALUE_EXTRACTING
    end

    protected

    def resolve_assigning(value)
      tree.resolve_assigning(value)
    end

    def resolve_retrieval(key)
      tree.resolve_retrieval(key)
    end

    def add_chain_link(key)
      tree.add_chain_link(extract_key(key))
    end

    def extract_key(key)
      extracted_key = key.to_s.split(Operations::VALUE_ASSIGNING).first
      extracted_key = extracted_key.split(Operations::VALUE_EXTRACTING).first
      extracted_key.to_sym
    end

    def tree
      @tree ||= Tree.new
    end
  end
end
