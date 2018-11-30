# frozen_string_literal: true

require 'hasher/kernel/errors/not_implemented_error'
require 'hasher/kernel/hasherizers/dumpers/main_dumper'
require 'hasher/kernel/hasherizers/dumpers/array_handler'
require 'hasher/kernel/hasherizers/dumpers/basic_type_handler'
require 'hasher/kernel/hasherizers/dumpers/default_handler'
require 'hasher/kernel/hasherizers/dumpers/composite_node_handler'
require 'hasher/kernel/hasherizers/dumpers/hasher_handler'
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
  def initialize(something = {})
    if something.is_a?(::Kernel::Tree)
      @tree = something
    end
  end
  # debug_method. TODO: remove after debugging
  def __tree
    action_resolver.instance_variable_get(:@tree)
  end

  # debug_method. TODO: remove after debugging
  def __pretty_print
    ::Kernel::TreePrinter.new.print(__tree)
  end

  def to_h
    ::Kernel::Hasherizer.new.to_h(tree.root)
  end

  def method_missing(method_name, *args)
    action = action_resolver.resolve(method_name, args, tree)
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
