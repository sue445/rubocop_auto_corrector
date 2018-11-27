RSpec.describe './exe/rubocop_auto_corrector' do
  include_context :setup_dummy_repo

  it 'running' do
    system! "#{spec_dir}/../exe/rubocop_auto_corrector"
  end
end
