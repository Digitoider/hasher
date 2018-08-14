# frozen_string_literal: true

module Kernel
  class Resolver
    def initialize

    end

    def resolve(key, args)
      operation = key.to_s.chars.last
      value = args.first
      add_chain_link(key)
      return resolve_assigning(value) if operation == '='
      resolve_retrieval(key)          if operation == '!'
    end

    protected

    def resolve_assigning(value)
      tree.assign_chain_link(value)
    end

    def resolve_retrieval(key)
      tree.resolve_retrieval(key)
    end

    def add_chain_link(key)
      tree.add_chain_link(key)
    end

    def tree
      @tree ||= Tree.new
    end
  end
end
