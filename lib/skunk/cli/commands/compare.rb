# frozen_string_literal: true

require "rubycritic/commands/compare"
require "skunk/rubycritic/analysed_modules_collection"

# nodoc #
module Skunk
  module Command
    # Knows how to compare two branches and their stink score average
    class Compare < RubyCritic::Command::Compare
      # switch branch and analyse files but don't generate a report
      def analyse_branch(branch)
        ::RubyCritic::SourceControlSystem::Git.switch_branch(::RubyCritic::Config.send(branch))
        critic = critique(branch)
        ::RubyCritic::Config.send(:"#{branch}_score=", critic.stink_score_average)
        ::RubyCritic::Config.root = branch_directory(branch)
      end

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
        FileUtils.mkdir_p(compare_root_directory) unless File.exists?(compare_root_directory)
        "#{compare_root_directory}/build_details.txt"
      end

      def compare_root_directory
        ::RubyCritic::Config.compare_root_directory
      end
    end
  end
end
