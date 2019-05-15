source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in rubocop_auto_corrector.gemspec
gemspec

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.3.0")
  # rubocop 0.69.0+ requires ruby 2.3+
  gem 'rubocop', '< 0.69.0'
end
