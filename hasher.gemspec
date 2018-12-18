# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'hasher'
  spec.version     = '1.1.0'
  spec.date        = '2018-12-18'
  spec.summary     = 'Work with hash the JavaScript way!'
  spec.description = 'This gem allows you to work with hash structure the JavaScript way!'
  spec.authors     = ['Alexander Brjakin']
  spec.email       = 'digitoider@gmail.com'
  spec.files       = ['lib/hasher']
  spec.require_paths = ['lib']
  spec.homepage    = 'http://rubygems.org/gems/hasher'
  spec.license     = 'MIT'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry-byebug'
end
