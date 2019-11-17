# frozen_string_literal: true

require "rubycritic/commands/compare"
require "skunk/rubycritic/analysed_modules_collection"

# nodoc #
module Skunk
  module Command
    # Knows how to compare two branches and their stink score average
    class Compare < RubyCritic::Command::Compare
      # def initialize(options)
      #   super
      #   @build_number = 0
      # end
      #
      # def execute
      #   compare_branches
      #   status_reporter.score = Config.feature_branch_score
      #   status_reporter
      # end
      #
      # private
      #
      # attr_reader :paths, :status_reporter
      #
      # def compare_branches
      #   @build_number = Utils::BuildNumberFile.new.update_build_number
      #   set_root_paths
      #   original_no_browser_config = Config.no_browser
      #   Config.no_browser = true
      #   analyse_branch(:base_branch)
      #   analyse_branch(:feature_branch)
      #   Config.no_browser = original_no_browser_config
      #   analyse_modified_files
      #   compare_code_quality
      # end
      #
      # def set_root_paths
      #   Config.base_root_directory = Pathname.new(branch_directory(:base_branch))
      #   Config.feature_root_directory = Pathname.new(branch_directory(:feature_branch))
      #   Config.compare_root_directory = Pathname.new("#{Config.root}/compare")
      # end
      #
      # switch branch and analyse files but don't generate a report
      def analyse_branch(branch)
        ::RubyCritic::SourceControlSystem::Git.switch_branch(::RubyCritic::Config.send(branch))
        critic = critique(branch)
        ::RubyCritic::Config.send(:"#{branch}_score=", critic.stink_score_average)
        ::RubyCritic::Config.root = branch_directory(branch)
      end

      #
      # generate report only for modified files but don't report it
      def analyse_modified_files
        modified_files = ::RubyCritic::Config
                         .feature_branch_collection
                         .where(::RubyCritic::SourceControlSystem::Git.modified_files)
        ::RubyCritic::AnalysedModulesCollection.new(modified_files.map(&:path),
                                                    modified_files)
        ::RubyCritic::Config.root = "#{::RubyCritic::Config.root}/compare"
      end

      # create a txt file with the branch score details
      def build_details
        details = "Base branch (#{::RubyCritic::Config.base_branch}) "\
                  "average stink score: #{::RubyCritic::Config.base_branch_score} \n"\
                  "Feature branch (#{::RubyCritic::Config.feature_branch}) "\
                  "average stink score: #{::RubyCritic::Config.feature_branch_score} \n"
        File.open(build_details_path, "w") { |file| file.write(details) }
        puts details
      end

      def build_details_path
        "#{::RubyCritic::Config.compare_root_directory}/build_details.txt"
      end
    end
  end
end
