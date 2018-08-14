# frozen_string_literal: true

module Kernel
  class Resolver
    def initialize

    end

    def resolve(key, args)
      operation = key.chars.last
      value = args.first
      return resolve_assigning(key, value) if operation == '='
      return resolve_retrieval(key, value) if operation == '!'
      resolve_chain_link(key, value)
    end

    protected

    def resolve_assigning(key, value)
      tree.assign_chain_link(key, value)
    end

    def resolve_retrieval(key, value)
      tree.resolve_retrieval(key, value)
    end

    def resolve_chain_link(key, value)
      tree.add_chain_link(key, value)
    end

    def tree
      @tree ||= Tree.new
    end
  end
end
