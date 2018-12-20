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
require 'hasher/kernel/operations'
require 'hasher/kernel/action_resolver'
require 'hasher/kernel/hasherizer'
require 'hasher/kernel/response'
require 'hasher/kernel/tree'
require 'hasher/kernel/tree_printer'

require 'pry-byebug'

class Hasher
  def self.indifferentiate_keys(*keys)
    indifferentiator = ::Kernel::Dirty::Indifferentiator.new
    keys.map { |key| indifferentiator.define(key) }
  end

  def self.indifferentiate_key(key)
    ::Kernel::Dirty::Indifferentiator.new.define(key)
  end

  def self.[](*array)
    result = Hasher.new
    return result if array == []
    array.each do |key, value|
      result[key] = value.dup
    end
    result
  end

  def initialize(initial_value = {})
    return if initial_value == {} || !initial_value.is_a?(Hash)
    hasher = ::Kernel::Hasherizer.new.to_hasher(initial_value)
    @tree = hasher.instance_variable_get(:@tree)
  end

  def to_h
    ::Kernel::Hasherizer.new.to_h(tree.root)
  end

  def dup
    Hasher.new(to_h)
  end

  def each
    return method_missing(:each) unless block_given?

    tree.keys.each do |key|
      value = method_missing(key)
      yield(key, value)
    end
  end

  def each_value
    return method_missing(:each_value) unless block_given?

    tree.keys.each do |key|
      value = method_missing(key)
      yield(value)
    end
  end

  def map
    return method_missing(:map) unless block_given?

    tree.keys.map do |key|
      value = method_missing(key)
      yield(key, value)
    end
  end

  def delete(key = nil)
    return method_missing(:delete) if key.nil?

    tree.delete_key(indifferentiator.define(key))
  end

  def delete_if
    return method_missing(:delete_if) unless block_given?

    tree.keys.each do |key|
      value = method_missing(key)
      delete(key) if yield(key, value)
    end
    self
  end

  def reject
    return method_missing(:reject) unless block_given?

    rejected = []
    tree.keys.each do |key|
      value = method_missing(key)
      rejected << [key, value] unless yield(key, value)
    end
    Hasher[*rejected]
  end

  def keep_if
    return method_missing(:keep_if) unless block_given?

    tree.keys.each do |key|
      value = method_missing(key)
      delete(key) unless yield(key, value)
    end
    self
  end

  def select
    return method_missing(:select) unless block_given?

    selected = []
    tree.keys.each do |key|
      value = method_missing(key)
      selected << [key, value] if yield(key, value)
    end
    Hasher[*selected]
  end

  def dig(*keys)
    return method_missing(:dig) if keys.count.zero?

    value = method_missing(keys.shift)
    keys.each { |key| value = value[key] rescue nil }
    value
  end

  def ==(other)
    to_h == other.to_h rescue false
  end

  def key?(key)
    indifferent_key = indifferentiator.define(key)
    tree.keys.include?(indifferent_key)
  end

  def value?(value)
    hash  = to_h
    value = Hasher.new(value: value).to_h[:value]
    key   = hash.keys.find { |k| hash[k] == value }
    !key.nil?
  end

  def empty?
    to_h == {}
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

  def indifferentiator
    @indifferentiator ||= ::Kernel::Dirty::Indifferentiator.new
  end
end
