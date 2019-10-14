# frozen_string_literal: true

module Skunk
  module Command
    class StatusReporter < RubyCritic::Command::StatusReporter
      def update_status_message
        case @status
        when SUCCESS
          @status_message = "StinkScore: #{score}"
        when SCORE_BELOW_MINIMUM
          @status_message = "StinkScore (#{score}) is below the minimum #{@options[:minimum_score]}"
        end
      end
    end
  end
end
