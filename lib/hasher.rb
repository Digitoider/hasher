# frozen_string_literal: true

require 'hasher/kernel/resolver'
require 'hasher/kernel/types/tree'
require 'hasher/kernel/operations'
require 'hasher/kernel/tree'

require 'pry-byebug'

class Hasher

  def method_missing(method_name, *args)
    result = resolver.resolve(method_name, args)
    return result if retrieval?(method_name)
    self
  end

  # TODO: redirect all standard methods to method_missing
  # def to_s; method_missing(:to_s); end
  # and so on

  protected

  def retrieval?(method_name)
    method_name.to_s.chars.last == ::Kernel::Operations::VALUE_EXTRACTING
  end

  def resolver
    @resolver ||= ::Kernel::Resolver.new
  end
end
