RSpec.shared_context :setup_dummy_repo do
  include_context "within temp dir"

  before do
    Dir.glob("#{spec_dir}/dummy/*.rb").each do |src|
      FileUtils.cp(src, ".")
    end

    system! "git init"
    system! "git add ."
    system! "git commit -m 'Initial commit'"
  end
end
