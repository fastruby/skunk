# frozen_string_literal: true

require "rubycritic/cli/options/argv"

module Skunk
  module Cli
    # :nodoc:
    class Options
      # Extends RubyCritic::Cli::Options::Argv to parse a subset of the
      # parameters accepted by RubyCritic
      class Argv < RubyCritic::Cli::Options::Argv
        # :reek:Attribute
        attr_accessor :output_filename

        def parse # rubocop:disable Metrics/MethodLength
          parser.new do |opts|
            opts.banner = "Usage: skunk [options] [paths]\n"

            opts.on("-b", "--branch BRANCH", "Set branch to compare") do |branch|
              self.base_branch = String(branch)
              set_current_branch
              self.mode = :compare_branches
            end

            opts.on("-o", "--out FILE", "Output report to file") do |filename|
              self.output_filename = filename
            end

            opts.on_tail("-v", "--version", "Show gem's version") do
              self.mode = :version
            end

            opts.on_tail("-h", "--help", "Show this message") do
              self.mode = :help
            end
          end.parse!(@argv)
        end

        def to_h
          super.merge(output_filename: output_filename)
        end
      end
    end
  end
end
