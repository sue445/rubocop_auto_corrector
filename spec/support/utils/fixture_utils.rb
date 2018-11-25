module FixtureUtils
  def fixture(file)
    spec_dir.join("support", "fixtures", file).read
  end
end

RSpec.configure do |config|
  config.include FixtureUtils
end
