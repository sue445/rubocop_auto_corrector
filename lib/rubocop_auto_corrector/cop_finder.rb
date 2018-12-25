module RubocopAutoCorrector
  class CopFinder
    attr_reader :cop_name

    # @param cop_name [String] e.g. Metrics/AbcSize
    def initialize(cop_name)
      @cop_name = cop_name
    end

    # Whether this cop is auto correctable
    # @return [Boolean]
    def auto_correctable?
      Object.new.instance_eval <<-RUBY
        begin
          require '#{gem_name}'
        rescue LoadError
        end
        #{cop_class_name}.new.respond_to?(:autocorrect)
      RUBY
    rescue NameError
      false
    end

    # @return [String]
    def gem_name
      gem_name, = rubocop_cop_info
      gem_name
    end

    # @return [String]
    def cop_class_name
      _, cop_class = rubocop_cop_info
      cop_class
    end

    private

    def rubocop_cop_info
      cop_class_suffix = cop_name.gsub('/', '::')

      case cop_name
      when %r{^RSpec/}
        ['rubocop-rspec', "::RuboCop::Cop::#{cop_class_suffix}"]
      when %r{^(FactoryBot|Capybara)/}, 'Rails/HttpStatus'
        ['rubocop-rspec', "::RuboCop::Cop::RSpec::#{cop_class_suffix}"]
      when %r{^(Layout|Lint|Metrics|Naming|Performance|Rails|Security|Style|Bundler|Gemspec)/}
        # Official cops
        ['rubocop', "::RuboCop::Cop::#{cop_class_suffix}"]
      else
        # Unknown cops
        department_camel = cop_name.split('/').first
        department_snake = department_camel.gsub(/(?<=.)([A-Z])/) { |s| "_#{s}" }.downcase
        ["rubocop-#{department_snake}", "::RuboCop::Cop::#{cop_class_suffix}"]
      end
    end
  end
end