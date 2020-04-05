# frozen_string_literal: true

require "rubycritic/commands/compare"
require "skunk/rubycritic/analysed_modules_collection"
require "skunk/cli/commands/output"

# nodoc #
module Skunk
  module Command
    # Knows how to compare two branches and their skunk score average
    class Compare < RubyCritic::Command::Compare
      # switch branch and analyse files but don't generate a report
      def analyse_branch(branch)
        ::RubyCritic::SourceControlSystem::Git.switch_branch(::RubyCritic::Config.send(branch))
        critic = critique(branch)
        ::RubyCritic::Config.send(:"#{branch}_score=", critic.skunk_score_average)
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
          "average skunk score: #{::RubyCritic::Config.base_branch_score.to_f.round(2)} \n"\
          "Feature branch (#{::RubyCritic::Config.feature_branch}) "\
          "average skunk score: #{::RubyCritic::Config.feature_branch_score.to_f.round(2)} \n"
        Skunk::Command::Output.create_directory(::RubyCritic::Config.compare_root_directory)
        File.open(build_details_path, "w") { |file| file.write(details) }
        puts details
      end

      def build_details_path
        "#{::RubyCritic::Config.compare_root_directory}/build_details.txt"
      end
    end
  end
end
