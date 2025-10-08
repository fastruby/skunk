# frozen_string_literal: true

module Skunk
  module Command
    # This is a module that will be used for sharing reports to a server
    module Shareable
      # It shares the report using SHARE_URL or https://skunk.fastruby.io. It
      # will post all results in JSON format and return a status message.
      #
      # @param [Skunk::Command::StatusReporter] A status reporter with analysed modules
      # :reek:FeatureEnvy
      def share(reporter)
        sharer = Skunk::Command::StatusSharer.new(@options)
        sharer.status_reporter = reporter
        sharer.share
      end

      # @return [Boolean] If the environment is set to share to an external
      # service
      def sharing?
        share_enabled?
      end

      private

      # @return [Boolean] Check if sharing is enabled via environment variable
      def share_enabled?
        ENV["SHARE"] == "true"
      end
    end
  end
end
