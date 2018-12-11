# frozen_string_literal: true

require 'hasher/kernel/errors/not_implemented_error'
require 'hasher/kernel/dirty/array_substitute'
require 'hasher/kernel/dirty/indifferentiator'
require 'hasher/kernel/hasherizers/dumpers/main_dumper'
require 'hasher/kernel/hasherizers/dumpers/base_handler'
require 'hasher/kernel/hasherizers/dumpers/array_handler'
require 'hasher/kernel/hasherizers/dumpers/basic_type_handler'
require 'hasher/kernel/hasherizers/dumpers/default_handler'
require 'hasher/kernel/hasherizers/dumpers/composite_node_handler'
require 'hasher/kernel/hasherizers/dumpers/hasher_handler'
require 'hasher/kernel/hasherizers/dumpers/key_value_pair_nil_handler'
require 'hasher/kernel/hasherizers/loaders/main_loader'
require 'hasher/kernel/hasherizers/loaders/default_loader'
require 'hasher/kernel/hasherizers/loaders/array_loader'
require 'hasher/kernel/hasherizers/loaders/hash_loader'
require 'hasher/kernel/nodes/base'
require 'hasher/kernel/nodes/leaf'
require 'hasher/kernel/nodes/composite'
require 'hasher/kernel/resolvers/base_resolver'
require 'hasher/kernel/resolvers/array_resolver'
require 'hasher/kernel/resolvers/basic_class_resolver'
require 'hasher/kernel/resolvers/default_resolver'
require 'hasher/kernel/resolvers/hash_resolver'
require 'hasher/kernel/resolvers/main_resolver'
require 'hasher/kernel/types/tree'
require 'hasher/kernel/operations'
require 'hasher/kernel/action_resolver'
require 'hasher/kernel/hasherizer'
require 'hasher/kernel/response'
require 'hasher/kernel/tree'
require 'hasher/kernel/tree_printer'
require 'hasher/kernel/serializers/hasherizer'

require 'pry-byebug'

class Hasher
  def initialize(initial_value = {})
    return if initial_value == {} || !initial_value.is_a?(Hash)
    hasher = ::Kernel::Hasherizer.new.to_hasher(initial_value)
    @tree = hasher.instance_variable_get(:@tree)
  end

  def to_h
    ::Kernel::Hasherizer.new.to_h(tree.root)
  end

  def each
    return method_missing(:each) unless block_given?

    keys = tree.keys
    keys.each do |key|
      value = method_missing(key)
      yield(key, value)
    end
  end

  def map
    return method_missing(:map) unless block_given?

    tree.keys.map do |key|
      value = method_missing(key)
      yield(key, value)
    end
  end

  def has_key?(key)
    tree.keys.include?(key)
  end

  def []=(key, value)
    action_resolver.resolve_assigning(key, value, tree)
    # self
  end

  def [](key)
    action_resolver.resolve_retrieval(key, tree).value
  end

  def method_missing(method_name, *args)
    action = action_resolver.resolve(method_name, args.first, tree)
    return self if action.assigned?
    action.value
  end

  # TODO: redirect all standard methods to method_missing
  # def to_s; method_missing(:to_s); end
  # and so on

  protected

  def tree
    @tree ||= ::Kernel::Tree.new
  end

  def action_resolver
    @action_resolver ||= ::Kernel::ActionResolver.new
  end
end
