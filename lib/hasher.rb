# frozen_string_literal: true

require 'hasher/kernel/resolver'
require 'hasher/kernel/types/tree'
require 'hasher/kernel/operations'
require 'hasher/kernel/tree'
require 'hasher/kernel/tree_printer'

require 'pry-byebug'

class Hasher
  def __not_working_cases
    h.a = [1, { b: { c: 2 } }]
    # => [1, {:b=>{:c=>2}}]
    h.a[1].b.c
    # => 2
    h.a[1].b.d
    # => 2
    h.a[1].b.asdf
    # => 2

    # -------

    h.a = [1, {b: {c: 2, d: {e: 4}}}]
    # => [1, {:b=>{:c=>2, :d=>{:e=>4}}}]
    h.a[1].b.d.e
    # => 4
    h.a[1].b.d.ds
    # => 4
  end

  def initialize(something = {})
    if something.is_a?(::Kernel::Tree)
      @tree = something
    end
  end
  # debug_method. TODO: remove after debugging
  def __tree
    resolver.instance_variable_get(:@tree)
  end

  # debug_method. TODO: remove after debugging
  def __pretty_print
    ::Kernel::TreePrinter.new.print(__tree)
  end

  def method_missing(method_name, *args)
    action = resolver.resolve(method_name, args, tree)
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

  def resolver
    @resolver ||= ::Kernel::Resolver.new
  end
end
