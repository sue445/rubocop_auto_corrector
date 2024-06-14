# frozen_string_literal: true

module RubocopAutoCorrector
  class CopFinder
    attr_reader :cop_name

    # @param cop_name [String] e.g. Metrics/AbcSize
    def initialize(cop_name)
      @cop_name = cop_name
    end

    # Whether this cop is auto correctable
    # @return [Boolean]
    def auto_correctable? # rubocop:disable Metrics/MethodLength
      cop_candidacies.any? do |cop_candidacy|
        gem_name = cop_candidacy[:gem_name]
        cop_class_name = cop_candidacy[:cop_class_name]

        Object.new.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          # begin
          #   require 'rubocop-rspec'
          # rescue LoadError
          # end
          #
          # return ::RuboCop::Cop::RSpec::AlignLeftLetBrace.support_autocorrect? if ::RuboCop::Cop::RSpec::AlignLeftLetBrace.respond_to?(:support_autocorrect?)
          # ::RuboCop::Cop::RSpec::AlignLeftLetBrace.new.respond_to?(:autocorrect)

          begin
            require '#{gem_name}'
          rescue LoadError
          end

          return #{cop_class_name}.support_autocorrect? if #{cop_class_name}.respond_to?(:support_autocorrect?)
          #{cop_class_name}.new.respond_to?(:autocorrect)
        RUBY
      rescue NameError
        false
      end
    end

    # rubocop:disable Metrics/MethodLength
    # @return [Array<Hash<Symbol, String>>]
    def cop_candidacies
      cop_class_suffix = cop_name.gsub('/', '::')

      case cop_name
      when %r{^RSpec/}
        [
          {
            gem_name: 'rubocop-rspec',
            cop_class_name: "::RuboCop::Cop::#{cop_class_suffix}"
          }
        ]
      when 'Rails/HttpStatus'
        [
          # for rubocop-rspec < 2.28.0
          {
            gem_name: 'rubocop-rspec',
            cop_class_name: "::RuboCop::Cop::RSpec::#{cop_class_suffix}"
          }
        ]
      when %r{^FactoryBot/}
        [
          # for rubocop-rspec < 2.0.0
          {
            gem_name: 'rubocop-rspec',
            cop_class_name: "::RuboCop::Cop::RSpec::#{cop_class_suffix}"
          },
          # for rubocop-rspec v3+
          {
            gem_name: 'rubocop-factory_bot',
            cop_class_name: "::RuboCop::Cop::#{cop_class_suffix}"
          }
        ]
      when %r{^Capybara/}
        [
          # for rubocop-rspec < 2.0.0
          {
            gem_name: 'rubocop-rspec',
            cop_class_name: "::RuboCop::Cop::RSpec::#{cop_class_suffix}"
          },
          # for rubocop-rspec v3+
          {
            gem_name: 'rubocop-capybara',
            cop_class_name: "::RuboCop::Cop::#{cop_class_suffix}"
          }
        ]
      when %r{^(Layout|Lint|Metrics|Naming|Security|Style|Bundler|Gemspec)/}
        # Official cops
        [
          {
            gem_name: 'rubocop',
            cop_class_name: "::RuboCop::Cop::#{cop_class_suffix}"
          }
        ]
      else
        # Unknown cops
        department_camel = cop_name.split('/').first
        department_snake = department_camel.gsub(/(?<=.)([A-Z])/) { |s| "_#{s}" }.downcase

        [
          {
            gem_name: "rubocop-#{department_snake}",
            cop_class_name: "::RuboCop::Cop::#{cop_class_suffix}"
          }
        ]
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
