# frozen_string_literal: true

RSpec.describe './exe/rubocop_auto_corrector' do
  include_context 'setup dummy repo'

  context 'without arg' do
    it 'running' do
      system! "#{spec_dir}/../exe/rubocop_auto_corrector"
    end
  end

  context 'with --all' do
    it 'running' do
      system! "#{spec_dir}/../exe/rubocop_auto_corrector --all"
    end
  end
end
