# frozen_string_literal: true

class Hasher

  def method_missing(method_name, *args)
    resolver.resolve(method_name, args)
  end

  protected

  def resolver
    @resolver ||= ::Kernel::Resolver.new
  end
end
