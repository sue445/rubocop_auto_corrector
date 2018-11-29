RSpec.describe RubocopAutoCorrector::CLI do
  let(:cli) { RubocopAutoCorrector::CLI.new }

  describe '#perform' do
    subject { cli.perform }

    include_context 'setup dummy repo'

    it 'auto correct and commit' do
      subject

      example1 = File.read('example1.rb')
      example2 = File.read('example2.rb')

      git_log = `git --no-pager log --oneline`.strip
      rubocop_commits = git_log.each_line.reject { |line| line =~ /Initial commit/ }

      aggregate_failures do
        expect(example1).to eq(<<-RUBY)
def badName
  test if something
end
        RUBY

        expect(example2).to eq(<<-RUBY)
class Foo
  def self.someMethod
    puts 'test'
  end
end
        RUBY

        expect(rubocop_commits.count).to be >= 1
        expect(rubocop_commits).to all(match(/^[0-9a-z]{7} :cop: rubocop --auto-correct --only /))
      end
    end
  end

  describe '#collect_offense_cop_names' do
    subject { cli.collect_offense_cop_names }

    before do
      allow(cli).to receive(:run_rubocop_for_collect) { fixture('rubocop.json') }
    end

    let(:expected_cops) do
      %w[
        Layout/DefEndAlignment
        Layout/EndAlignment
        Naming/MethodName
        Style/ColonMethodDefinition
        Style/Documentation
        Style/GuardClause
        Style/IfUnlessModifier
        Style/StringLiterals
      ]
    end

    it { is_expected.to match_array(expected_cops) }
  end

  describe '#auto_correctable?' do
    subject { cli.auto_correctable?(cop_name) }

    using RSpec::Parameterized::TableSyntax

    where(:cop_name, :expected) do
      'Layout/AccessModifierIndentation'  | true
      'Metrics/AbcSize'                   | false
      'FactoryBot/CreateList'             | true
      'Aaaaa/Invalid'                     | false
    end

    with_them do
      it { is_expected.to eq expected }
    end
  end

  describe '#rubocop_gem_name' do
    subject { cli.rubocop_gem_name(cop_name) }

    using RSpec::Parameterized::TableSyntax

    where(:cop_name, :gem_name) do
      'Layout/AccessModifierIndentation'  | 'rubocop'
      'Metrics/AbcSize'                   | 'rubocop'
      'Rails/ActionFilter'                | 'rubocop'
      'Rails/HttpStatus'                  | 'rubocop-rspec'
      'RSpec/AlignLeftLetBrace'           | 'rubocop-rspec'
      'FactoryBot/CreateList'             | 'rubocop-rspec'
      'Capybara/CurrentPathExpectation'   | 'rubocop-rspec'
      'Itamae/CdInExecute'                | 'rubocop-itamae'
    end

    with_them do
      it { is_expected.to eq gem_name }
    end
  end

  describe '#rubocop_cop_class' do
    subject { cli.rubocop_cop_class(cop_name) }

    using RSpec::Parameterized::TableSyntax

    where(:cop_name, :cop_class) do
      'Layout/AccessModifierIndentation'  | '::RuboCop::Cop::Layout::AccessModifierIndentation'
      'Metrics/AbcSize'                   | '::RuboCop::Cop::Metrics::AbcSize'
      'Rails/ActionFilter'                | '::RuboCop::Cop::Rails::ActionFilter'
      'Rails/HttpStatus'                  | '::RuboCop::Cop::RSpec::Rails::HttpStatus'
      'RSpec/AlignLeftLetBrace'           | '::RuboCop::Cop::RSpec::AlignLeftLetBrace'
      'FactoryBot/CreateList'             | '::RuboCop::Cop::RSpec::FactoryBot::CreateList'
      'Capybara/CurrentPathExpectation'   | '::RuboCop::Cop::RSpec::Capybara::CurrentPathExpectation'
      'Itamae/CdInExecute'                | '::RuboCop::Cop::Itamae::CdInExecute'
    end

    with_them do
      it { is_expected.to eq cop_class }
    end
  end
end
