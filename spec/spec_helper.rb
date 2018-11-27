require "bundler/setup"
require "rubocop_auto_corrector"
require "rubocop_auto_corrector/cli"
require "rspec/temp_dir"

Dir["#{__dir__}/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def spec_dir
  Pathname(__dir__)
end
