# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in rubocop_auto_corrector.gemspec
gemspec

# rubocop:disable Gemspec/DevelopmentDependencies
if Gem::Version.create(RUBY_VERSION) >= Gem::Version.create('2.7.0')
  gem 'rubocop-factory_bot'
end
# rubocop:enable Gemspec/DevelopmentDependencies

# FIXME: Workaround for Ruby 4.0+
# ref. https://github.com/banister/binding_of_caller/pull/90
gem 'binding_of_caller', github: 'kivikakk/binding_of_caller', branch: 'push-yrnnzolypxun'
