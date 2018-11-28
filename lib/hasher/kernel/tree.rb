# frozen_string_literal: true

module Kernel
  module Errors
    class NotImpementedError < StandardError
      def initialize(method_name)
        message = "`#{method_name}` is not implemented."
        super(message)
      end
    end
  end

  class Node
    attr_reader :value, :key

    def initialize(key: nil, value: nil)
      @key = key
      @value = value
    end

    def leaf?
      raise Errors::NotImpementedError.new(:leaf?)
    end

    def composite?
      raise Errors::NotImpementedError.new(:composite?)
    end
  end

  class Leaf < Node
    # attr_writer :value

    def leaf?
      true
    end

    def composite?
      false
    end

    def value=(node)
      @value = node.value
    end

    def value
      return @value unless @value.is_a?(Array)

      @value.map do |elem|
        elem.is_a?(Node) ? elem.value : elem
      end
    end
  end

  class Composite < Node
    def leaf?
      false
    end

    def composite?
      true
    end

    def children
      @children ||= []
    end

    def retrieve_child(key)
      children.find { |node| node.key == key }
    end

    def value=(node)
      found_child = children.find { |child| child.key == node.key }
      found_child.nil? ? children << node : found_child.value = node
    end

    def <<(node)
      found_child = children.find { |child| child.key == node.key }
      found_child.nil? ? children << node : found_child.value = node
    end
  end

  class Action
    attr_reader :value

    def initialize(assigned: false, retrieved: false, value: nil)
      @assigned = assigned
      @retrieved = retrieved
      @value = value
    end

    def assigned?
      @assigned
    end

    def retrieved?
      @retrieved
    end
  end

  module Resolvers
    class BaseResolver
      def resolve(_key, _value)
        raise ::Kernel::Errors::NotImpementedError.new(:resolve)
      end

      def can_resolve?(_value)
        raise ::Kernel::Errors::NotImpementedError.new(:can_resolve?)
      end
    end

    class MainResolver
      def resolve(key: nil, value:)
        found_resolver = resolvers.find do |resolver|
          # binding.pry
          resolver.can_resolve?(value)
        end

        found_resolver.resolve(key: key, value: value)
      end

      def resolvers
        @resolvers ||= [
          ::Kernel::Resolvers::BasicClassResolver.new,
          ::Kernel::Resolvers::ArrayResolver.new,
          ::Kernel::Resolvers::HashResolver.new,
          ::Kernel::Resolvers::DefaultResolver.new
        ]
      end
    end

    class ArrayResolver < BaseResolver
      def resolve(key: nil, value:)
        if basic_classes?(value)
          return ::Kernel::Leaf.new(key: key, value: value)
        end

        main_resolver = ::Kernel::Resolvers::MainResolver.new
        nodes = value.map do |elem|
          # binding.pry
          main_resolver.resolve(key: key, value: elem)
        end
        # binding.pry
        ::Kernel::Leaf.new(key: key, value: nodes)
      end

      def can_resolve?(value)
        value.is_a?(Array)
      end

      def basic_classes?(value)
        basic_class_resolver = ::Kernel::Resolvers::BasicClassResolver.new
        value.all? { |elem| basic_class_resolver.can_resolve?(elem) }
      end
    end

    class HashResolver < BaseResolver
      def resolve(key: nil, value:)
        hasher = ::Hasher.new

        value.each { |k, v| hasher.send(create_assiging(k), v) }

        # hasher
        ::Kernel::Leaf.new(key: key, value: hasher)
      end

      def can_resolve?(value)
        value.is_a?(Hash)
      end

      protected

      def create_assiging(name)
        "#{name}=".to_sym
      end
    end

    class BasicClassResolver < BaseResolver
      BASIC_TYPES = [String, Numeric, Integer, Symbol, TrueClass, FalseClass, NilClass]

      def resolve(key: nil, value:)
        ::Kernel::Leaf.new(key: key, value: value)
      end

      def can_resolve?(value)
        BASIC_TYPES.include?(value.class)
      end
    end

    class DefaultResolver < BaseResolver
      def resolve(key: nil, value:)
        ::Kernel::Leaf.new(key: key, value: value)
      end

      def can_resolve?(_value)
        true
      end
    end
  end

  class Tree
    attr_accessor :root

    def initialize(root: nil)
      @root = define_root(root)
    end

    def assign(extracted_key, value)
      node = main_resolver.resolve(key: extracted_key, value: value)
      # binding.pry

      if @root.composite?
        return @root << node
      end

      if @root.key.nil? || @root.key == extracted_key
        return @root = node
      end

      # if @root.key == extracted_key
      #   return @root.value = node.value
      # end

      composite_node = ::Kernel::Composite.new(key: '__abra')
      composite_node << @root
      composite_node << node
      @root = composite_node
    end

    def retrieve(key)
      # binding.pry if key == :labuda

      # if @root.value.is_a?(Array)
      #   return @root.value.map(&:value)
      # end
      return nil if @root.leaf? && @root.key != key
      return @root.value if @root.leaf?
      node = root.retrieve_child(key)
      leaf?(node) ? node.value : node
    end

    protected

    def define_root(root)
      node?(root) ? root : ::Kernel::Leaf.new(key: nil, value: root)
    end

    def node?(node)
      node.is_a?(::Kernel::Node)
    end

    def main_resolver
      @main_resolver ||= ::Kernel::Resolvers::MainResolver.new
    end

    def leaf?(node)
      node.leaf? rescue false
    end
  end
end
