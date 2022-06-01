# frozen_string_literal: true

module RubocopAutoCorrector
  require 'json'
  require 'yaml'
  require 'rubocop'
  require 'rubocop_auto_corrector'

  class CLI
    DEFAULT_ORDER = 100

    def initialize
      data = YAML.load_file("#{__dir__}/data.yml")
      @cop_orders = data['cop_orders']
      @exclude_cops = data['exclude_cops']
    end

    def perform(auto_collect_all)
      rubocop_option = auto_collect_all ? '--autocorrect-all' : '--autocorrect'

      cop_names = collect_offense_cop_names.select { |cop_name| auto_correctable?(cop_name) }
                                           .sort_by { |cop_name| [cop_order(cop_name), cop_name] }

      cop_names.each do |cop_name|
        if (reason = exclude_reason(cop_name))
          puts reason
          next
        end

        run_and_commit "rubocop #{rubocop_option} --only #{cop_name}"
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

    # Whether this cop is auto correctable
    #
    # @param cop_name [String]
    #
    # @return [Boolean]
    def auto_correctable?(cop_name)
      RubocopAutoCorrector::CopFinder.new(cop_name).auto_correctable?
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
  end
end
