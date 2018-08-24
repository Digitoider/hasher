# frozen_string_literal: true

module Tree
  class NotImplementedError < StandardError
  end

  class INode
    attr_accessor :key, :value, :nodes

    def leaf?
      raise NotImplementedError, 'Method `.leaf?` must be implemented.'
    end

    def composite?
      raise NotImplementedError, 'Method `.composite?` must be implemented.'
    end
  end
end