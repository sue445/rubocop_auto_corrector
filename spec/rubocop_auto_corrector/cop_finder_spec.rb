# frozen_string_literal: true

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

  describe '#cop_candidacies' do
    subject { finder.cop_candidacies }

    using RSpec::Parameterized::TableSyntax

    # rubocop:disable Layout/LineLength
    where(:cop_name, :cop_candidacies) do
      'Layout/AccessModifierIndentation' | [{ gem_name: 'rubocop',               cop_class_name: '::RuboCop::Cop::Layout::AccessModifierIndentation' }]
      'Metrics/AbcSize'                  | [{ gem_name: 'rubocop',               cop_class_name: '::RuboCop::Cop::Metrics::AbcSize' }]
      'Rails/ActionFilter'               | [{ gem_name: 'rubocop-rails',         cop_class_name: '::RuboCop::Cop::Rails::ActionFilter' }]
      'RSpec/AlignLeftLetBrace'          | [{ gem_name: 'rubocop-rspec',         cop_class_name: '::RuboCop::Cop::RSpec::AlignLeftLetBrace' }]
      'Itamae/CdInExecute'               | [{ gem_name: 'rubocop-itamae',        cop_class_name: '::RuboCop::Cop::Itamae::CdInExecute' }]
      'ThreadSafety/NewThread'           | [{ gem_name: 'rubocop-thread_safety', cop_class_name: '::RuboCop::Cop::ThreadSafety::NewThread' }]
      'Performance/Caller'               | [{ gem_name: 'rubocop-performance',   cop_class_name: '::RuboCop::Cop::Performance::Caller' }]

      # for rubocop-rspec < v2, v3+
      'Capybara/CurrentPathExpectation' | [{ gem_name: 'rubocop-rspec', cop_class_name: '::RuboCop::Cop::RSpec::Capybara::CurrentPathExpectation' }, { gem_name: 'rubocop-capybara',    cop_class_name: '::RuboCop::Cop::Capybara::CurrentPathExpectation' }]
      'FactoryBot/CreateList'           | [{ gem_name: 'rubocop-rspec', cop_class_name: '::RuboCop::Cop::RSpec::FactoryBot::CreateList' },           { gem_name: 'rubocop-factory_bot', cop_class_name: '::RuboCop::Cop::FactoryBot::CreateList' }]
      'Rails/HttpStatus'                | [{ gem_name: 'rubocop-rspec', cop_class_name: '::RuboCop::Cop::RSpec::Rails::HttpStatus' }]

      # for. rubocop-rspec v2
      'RSpec/Capybara/CurrentPathExpectation' | [{ gem_name: 'rubocop-rspec', cop_class_name: '::RuboCop::Cop::RSpec::Capybara::CurrentPathExpectation' }]
      'RSpec/FactoryBot/CreateList'           | [{ gem_name: 'rubocop-rspec', cop_class_name: '::RuboCop::Cop::RSpec::FactoryBot::CreateList' }]
      'RSpec/Rails/HttpStatus'                | [{ gem_name: 'rubocop-rspec', cop_class_name: '::RuboCop::Cop::RSpec::Rails::HttpStatus' }]
    end
    # rubocop:enable Layout/LineLength

    with_them do
      it { is_expected.to eq cop_candidacies }
    end
  end
end
