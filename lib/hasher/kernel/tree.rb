# frozen_string_literal: true

module Kernel
  module TYPES
    module TREE
      TYPE_LEAF      = 1
      TYPE_COMPOSITE = 2
    end
  end

  class Tree
    attr_accessor :nodes, :type, :root, :chain, :key

    def initialize(type: TYPES::TREE::TYPE_LEAF, root: nil, key: nil)
      @nodes = []
      @type = type
      @root = root.nil? ? self : root
      @key  = key
      @chain = []
    end

    def resolve_assigning(value)
      current_node = @root
      @chain.each do |link|
        current_node = current_node.get_node!(link)
      end

      assign_value!(current_node, value)
      reset_chain!
    end

    def resolve_retrieval(key)
      value = find_value(@root, key)
      reset_chain!
      value
    end

    def add_chain_link(key)
      chain << key
    end

    protected

    def find_value(current_node, key)
      return current_node.nodes[0] if current_node.type == TYPES::TREE::TYPE_LEAF

      node = current_node.nodes.find { |node| node.key == key }
      return nil if node.nil?
      find_value(node, key)
    end

    def assign_value!(node, value)
      node.type = TYPES::TREE::TYPE_LEAF
      node.nodes << value
    end

    def reset_chain!
      @chain = []
    end

    def get_node!(link)
      node = @nodes.find { |node| node.key == link }
      node = Tree.new(type: TYPES::TREE::TYPE_COMPOSITE, root: @root) if node.nil?
      node
    end

    def find_node(link)
      @nodes.find do |node|
        node.key == link
      end
    end

    def create_node(link)
      @nodes << node.new(link) # @nodes << node.new(link, Tree.new)   ?????
    end
  end

  class Node
    attr_accessor :key, :value

    def initialize(key, value = nil)
      @key = key
      @value = value
    end
  end
end