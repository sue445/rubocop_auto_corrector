# frozen_string_literal: true

RSpec.shared_context 'setup dummy repo' do
  include_context 'within temp dir'

  before do
    Dir.glob("#{spec_dir}/dummy/*.rb").each do |src|
      FileUtils.cp(src, '.')
    end
    FileUtils.cp("#{spec_dir}/dummy/.rubocop.yml", '.')

    system! 'git init'
    system! 'git add .'
    system! "git commit -m 'Initial commit'"
  end
end
