module RubocopAutoCorrector
  require 'json'
  require 'yaml'
  require 'rubocop'

  class CLI
    DEFAULT_ORDER = 100

    def initialize
      data = YAML.load_file("#{__dir__}/data.yml")
      @cop_orders = data['cop_orders']
      @exclude_cops = data['exclude_cops']
    end

    def perform
      cop_names =
        collect_offense_cop_names
        .select { |cop_name| auto_correctable?(cop_name) }
        .sort_by { |cop_name| [cop_order(cop_name), cop_name] }

      cop_names.each do |cop_name|
        if (reason = exclude_reason(cop_name))
          puts reason
          next
        end

        run_and_commit "rubocop --auto-correct --only #{cop_name}"
      end
    end

    def collect_offense_cop_names
      rubocop_result = JSON.parse(run_rubocop_for_collect)

      cop_names = []
      rubocop_result['files'].each do |file|
        cop_names += file['offenses'].map { |offense| offense['cop_name'] }
      end
      cop_names.uniq
    end

    def auto_correctable?(cop_name)
      cop_class_name = "::RuboCop::Cop::#{cop_name.gsub('/', '::')}"
      plugin_name = "rubocop-#{cop_name.split('/').first.downcase}"

      begin
        Object.new.instance_eval <<-RUBY
          begin
            require '#{plugin_name}'
          rescue LoadError
          end
          #{cop_class_name}.new.respond_to?(:autocorrect)
        RUBY
      rescue NameError
        false
      end
    end

    def rubocop_gem_name(cop_name)
      gem_name, = rubocop_cop_info(cop_name)
      gem_name
    end

    def rubocop_cop_class(cop_name)
      _, cop_class = rubocop_cop_info(cop_name)
      cop_class
    end

    private

    def run_and_commit(command)
      ret = system command
      system "git commit -am ':cop: #{command}'" if ret
    end

    def run_rubocop_for_collect
      `rubocop --parallel --format=json`
    end

    def cop_order(cop_name)
      @cop_orders[cop_name] || DEFAULT_ORDER
    end

    def exclude_reason(cop_name)
      @exclude_cops[cop_name]
    end

    def rubocop_cop_info(cop_name)
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
        department = cop_name.split('/').first.downcase
        ["rubocop-#{department}", "::RuboCop::Cop::#{cop_class_suffix}"]
      end
    end
  end
end
