# frozen_string_literal: true

require 'hasher/kernel/resolver'
require 'hasher/kernel/tree'

class Hasher

  def method_missing(method_name, *args)
    resolver.resolve(method_name, args)
    self
  end

  # TODO: redirect all standard methods to method_missing
  # def to_s; method_missing(:to_s); end
  # and so on

  protected

  def resolver
    @resolver ||= ::Kernel::Resolver.new
  end
end
