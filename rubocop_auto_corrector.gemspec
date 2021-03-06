# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop_auto_corrector/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop_auto_corrector'
  spec.version       = RubocopAutoCorrector::VERSION
  spec.authors       = ['sue445']
  spec.email         = ['sue445@sue445.net']

  spec.summary       = 'Run `rubocop --auto-correct && git commit` with each cop.'
  spec.description   = 'Run `rubocop --auto-correct && git commit` with each cop.'
  spec.homepage      = 'https://github.com/sue445/rubocop_auto_corrector'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = spec.homepage
    spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency 'rubocop', '>= 1.13.0'

  spec.add_development_dependency 'bundler', '>= 1.17'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-parameterized'
  spec.add_development_dependency 'rspec-temp_dir', '>= 1.1.0'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov', '< 0.18.0'
  spec.add_development_dependency 'unparser', '>= 0.4.5'
end
