RSpec.describe RubocopAutoCorrector::CopFinder do
  let(:finder) { RubocopAutoCorrector::CopFinder.new(cop_name) }

  describe '#auto_correctable?' do
    subject { finder.auto_correctable? }

    using RSpec::Parameterized::TableSyntax

    where(:cop_name, :expected) do
      'Layout/AccessModifierIndentation'  | true
      'Metrics/AbcSize'                   | false
      'FactoryBot/CreateList'             | true
      'Aaaaa/Invalid'                     | false
      'ThreadSafety/NewThread'            | false
    end

    with_them do
      it { is_expected.to eq expected }
    end
  end

  describe '#gem_name' do
    subject { finder.gem_name }

    using RSpec::Parameterized::TableSyntax

    where(:cop_name, :gem_name) do
      'Layout/AccessModifierIndentation'  | 'rubocop'
      'Metrics/AbcSize'                   | 'rubocop'
      'Rails/ActionFilter'                | 'rubocop-rails'
      'Rails/HttpStatus'                  | 'rubocop-rspec'
      'RSpec/AlignLeftLetBrace'           | 'rubocop-rspec'
      'FactoryBot/CreateList'             | 'rubocop-rspec'
      'Capybara/CurrentPathExpectation'   | 'rubocop-rspec'
      'Itamae/CdInExecute'                | 'rubocop-itamae'
      'ThreadSafety/NewThread'            | 'rubocop-thread_safety'
      'Performance/Caller'                | 'rubocop-performance'
    end

    with_them do
      it { is_expected.to eq gem_name }
    end
  end

  describe '#cop_class_name' do
    subject { finder.cop_class_name }

    using RSpec::Parameterized::TableSyntax

    where(:cop_name, :cop_class_name) do
      'Layout/AccessModifierIndentation'  | '::RuboCop::Cop::Layout::AccessModifierIndentation'
      'Metrics/AbcSize'                   | '::RuboCop::Cop::Metrics::AbcSize'
      'Rails/ActionFilter'                | '::RuboCop::Cop::Rails::ActionFilter'
      'Rails/HttpStatus'                  | '::RuboCop::Cop::RSpec::Rails::HttpStatus'
      'RSpec/AlignLeftLetBrace'           | '::RuboCop::Cop::RSpec::AlignLeftLetBrace'
      'FactoryBot/CreateList'             | '::RuboCop::Cop::RSpec::FactoryBot::CreateList'
      'Capybara/CurrentPathExpectation'   | '::RuboCop::Cop::RSpec::Capybara::CurrentPathExpectation'
      'Itamae/CdInExecute'                | '::RuboCop::Cop::Itamae::CdInExecute'
      'ThreadSafety/NewThread'            | '::RuboCop::Cop::ThreadSafety::NewThread'
      'Performance/Caller'                | '::RuboCop::Cop::Performance::Caller'
    end

    with_them do
      it { is_expected.to eq cop_class_name }
    end
  end
end
