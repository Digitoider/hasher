# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'hasher'
  spec.version     = '0.0.1'
  spec.date        = '2018-08-09'
  spec.summary     = 'This gem provides ...'
  spec.description = 'This gem provides ...'
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
