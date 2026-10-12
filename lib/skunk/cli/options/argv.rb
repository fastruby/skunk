# frozen_string_literal: true

require "rubycritic/cli/options/argv"
require "skunk/config"

module Skunk
  module Cli
    # :nodoc:
    class Options
      # Extends RubyCritic::Cli::Options::Argv to parse a subset of the
      # parameters accepted by RubyCritic
      class Argv < RubyCritic::Cli::Options::Argv
        def parse
          parser.new do |opts|
            opts.banner = "Usage: skunk [options] [paths]\n"
            opts.on("-b", "--branch BRANCH", "Set branch to compare") do |branch|
              self.base_branch = String(branch)
              set_current_branch
              self.mode = :compare_branches
            end

            opts.on("-o", "--out PATH", "Output directory for reports") do |path|
              self.output_path = path
            end

            opts.on("-f", "--formats json,html,console", Array, "Output formats: json,html,console") do |list|
              Skunk::Config.formats = Array(list).map(&:to_sym)
            end

            opts.on_tail("-v", "--version", "Show gem's version") do
              self.mode = :version
            end

            opts.on_tail("-h", "--help", "Show this message") do
              self.mode = :help
            end
          end.parse!(@argv)
        end

        private

        # Moves only Skunk's reports. RubyCritic::Config.root stays under
        # RubyCritic's control, and Skunk::Config.root falls back to it
        def output_path=(path)
          raise OptionParser::InvalidArgument, "expects a directory" if path.to_s.strip.empty?
          raise OptionParser::InvalidArgument, "expects a directory, but #{path} is a file" if File.file?(path)

          Skunk::Config.root = path
        end
      end
    end
  end
end
