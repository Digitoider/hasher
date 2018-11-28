# frozen_string_literal: true

module Kernel
  class Response
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
end
