# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Loaders
      class MainLoader
        def to_hasher(hash)
          loader = loaders.find { |l| l.can_load?(hash) }

          loader.to_hasher(hash)
        end

        private

        def loaders
          [
            ::Kernel::Hasherizers::Loaders::HashLoader.new,
            ::Kernel::Hasherizers::Loaders::ArrayLoader.new,
            ::Kernel::Hasherizers::Loaders::DefaultLoader.new
          ]
        end
      end

      class HashLoader
        def to_hasher(hash)
          hasher = Hasher.new
          hash.each do |key, value|
            hasher.method_missing(build_assigning(key), value)
          end
          hasher
        end

        def can_load?(elem)
          elem.is_a?(Hash)
        end

        private

        def build_assigning(key)
          "#{key}=".to_sym
        end
      end

      class ArrayLoader
        def to_hasher(array)
          array.map do |elem|
            main_dumper.to_hasher(elem)
          end
        end

        def can_load?(elem)
          elem.is_a?(Array)
        end
      end

      class DefaultLoader
        def to_hasher(elem)
          elem
        end

        def can_load?(_elem)
          true
        end
      end
    end
  end

  class Hasherizer
    def to_h(node)
      ::Kernel::Hasherizers::Dumpers::MainDumper.new.to_h(node)
    end

    def to_hasher(hash)
      # TODO: deep symbolize hash
      ::Kernel::Hasherizers::Loaders::MainLoader.new.to_hasher(hash)
    end
  end
end
