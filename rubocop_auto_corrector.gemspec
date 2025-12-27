# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop_auto_corrector/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop_auto_corrector'
  spec.version       = RubocopAutoCorrector::VERSION
  spec.authors       = ['sue445']
  spec.email         = ['sue445@sue445.net']

  spec.summary       = 'Run `rubocop --autocorrect && git commit` with each cop.'
  spec.description   = 'Run `rubocop --autocorrect && git commit` with each cop.'
  spec.homepage      = 'https://github.com/sue445/rubocop_auto_corrector'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata['documentation_uri'] = 'https://sue445.github.io/rubocop_auto_corrector/'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'rubocop', '>= 1.30.0'

  spec.add_development_dependency 'bundler', '>= 1.17'
  spec.add_development_dependency 'coveralls_reborn'
  spec.add_development_dependency 'logger'
  spec.add_development_dependency 'ostruct'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-parameterized'
  spec.add_development_dependency 'rspec-temp_dir', '>= 1.1.0'
  spec.add_development_dependency 'rubocop', '>= 1.23.0'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov', '< 0.18.0'
  spec.add_development_dependency 'term-ansicolor', '!= 1.11.1' # ref. https://github.com/flori/term-ansicolor/issues/41
  spec.add_development_dependency 'unparser', '>= 0.4.5'
  spec.add_development_dependency 'yard'
end
