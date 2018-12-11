# frozen_string_literal: true

module Kernel
  class Tree
    attr_accessor :root

    def initialize(root: nil)
      @root = define_root(root)
    end

    def assign(extracted_key, value)
      node = main_resolver.resolve(key: extracted_key, value: value)

      return @root << node if @root.composite?
      return @root = node if @root.key.nil? || @root.key == extracted_key

      composite_node = ::Kernel::Nodes::Composite.new
      composite_node << @root
      composite_node << node
      @root = composite_node
    end

    def retrieve(key)
      return nil if @root.leaf? && @root.key != key
      return @root.value if @root.leaf?
      node = root.retrieve_child(key)
      leaf?(node) ? node.value : node
    end

    def keys
      return [] if @root.key.nil? && @root.value.nil?
      return [@root.key] if @root.leaf?
      @root.keys
    end

    protected

    def define_root(root)
      node?(root) ? root : ::Kernel::Nodes::Leaf.new(key: nil, value: root)
    end

    def node?(node)
      node.is_a?(::Kernel::Nodes::Base)
    end

    def main_resolver
      @main_resolver ||= ::Kernel::Resolvers::MainResolver.new
    end

    def leaf?(node)
      node.leaf? rescue false
    end
  end
end
