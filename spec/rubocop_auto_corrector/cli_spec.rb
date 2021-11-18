# frozen_string_literal: true

RSpec.describe RubocopAutoCorrector::CLI do
  let(:cli) { RubocopAutoCorrector::CLI.new }

  describe '#perform' do
    subject { cli.perform(auto_collect_all) }

    include_context 'setup dummy repo'

    context 'when auto_collect_all is false' do
      let(:auto_collect_all) { false }

      it 'auto correct and commit' do
        subject

        example1 = File.read('example1.rb')
        example2 = File.read('example2.rb')

        git_log = `git --no-pager log --oneline`.strip
        rubocop_commits = git_log.each_line.grep_v(/Initial commit/)

        aggregate_failures do
          expect(example1).to eq(<<~RUBY)
            def badName
              test if something
            end
          RUBY

          expect(example2).to eq(<<~RUBY)
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

    context 'when auto_collect_all is true' do
      let(:auto_collect_all) { true }

      it 'auto correct and commit' do
        subject

        example1 = File.read('example1.rb')
        example2 = File.read('example2.rb')

        git_log = `git --no-pager log --oneline`.strip
        rubocop_commits = git_log.each_line.grep_v(/Initial commit/)

        aggregate_failures do
          expect(example1).to eq(<<~RUBY)
            def badName
              test if something
            end
          RUBY

          expect(example2).to eq(<<~RUBY)
            class Foo
              def self.someMethod
                puts 'test'
              end
            end
          RUBY

          expect(rubocop_commits.count).to be >= 1
          expect(rubocop_commits).to all(match(/^[0-9a-z]{7} :cop: rubocop --auto-correct-all --only /))
        end
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
end
