# frozen_string_literal: true

require 'hasher/kernel/resolver'
require 'hasher/kernel/types/tree'
require 'hasher/kernel/operations'
require 'hasher/kernel/tree'
require 'hasher/kernel/pretty_printer'

require 'pry-byebug'

class Hasher

  # debug_method. TODO: remove after debugging
  def __tree
    resolver.instance_variable_get(:@tree)
  end

  # debug_method. TODO: remove after debugging
  def __pretty_print
    ::Kernel::PrettyPrinter.new.pretty_print(__tree)
  end

  def method_missing(method_name, *args)
    # binding.pry
    result = resolver.resolve(method_name, args)
    return result if permitted_to_return_result?(method_name, result)
    self
  end

  # TODO: redirect all standard methods to method_missing
  # def to_s; method_missing(:to_s); end
  # and so on

  protected

  def permitted_to_return_result?(method_name, value)
    retrieval?(method_name) && value_type_is_allowed?(value)
  end

  def value_type_is_allowed?(value)
    # binding.pry
    allowed_types = [String, Numeric, Integer, Array, Symbol, TrueClass, FalseClass, NilClass]
    allowed_types.include?(value.class)
  end

  def retrieval?(method_name)
    method_name.to_s.chars.last == ::Kernel::Operations::VALUE_EXTRACTING
  end

  def resolver
    @resolver ||= ::Kernel::Resolver.new
  end
end
