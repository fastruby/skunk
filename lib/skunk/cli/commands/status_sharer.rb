# frozen_string_literal: true

require "net/http"
require "net/https"
require "json"

require "skunk/cli/commands/status_reporter"
require "skunk/cli/generators/console_report"

module Skunk
  module Command
    # Knows how to share status to an API
    class StatusSharer < Skunk::Command::StatusReporter
      attr_reader :status_message

      DEFAULT_URL = "https://skunk.fastruby.io"
      def status_reporter=(status_reporter)
        self.analysed_modules = status_reporter.analysed_modules
      end

      def share
        return "" if not_sharing?

        response = post_payload

        @status_message =
          if Net::HTTPOK === response
            data = JSON.parse response.body
            "Shared at: #{File.join(base_url, data['id'])}"
          else
            "Error sharing report: #{response}"
          end
      end

      private

      # :reek:UtilityFunction
      def base_url
        ENV["SHARE_URL"] || DEFAULT_URL
      end

      def json_summary
        result = {
          total_skunk_score: total_skunk_score,
          analysed_modules_count: analysed_modules_count,
          skunk_score_average: skunk_score_average,
          skunk_version: Skunk::VERSION
        }

        if worst
          result[:worst_skunk_score] = {
            file: worst.pathname.to_s,
            skunk_score: worst.skunk_score
          }
        end

        result
      end

      def json_results
        sorted_modules.map(&:to_hash)
      end

      # :reek:UtilityFunction
      def not_sharing?
        ENV["SHARE"] != "true" && ENV["SHARE_URL"].to_s == ""
      end

      def payload
        JSON.generate(
          "entries" => json_results,
          "summary" => json_summary,
          "options" => {
            "compare" => "false"
          }
        )
      end

      # :reek:TooManyStatements
      def post_payload
        req = Net::HTTP::Post.new(url)
        req.body = payload

        http = Net::HTTP.new(url.hostname, url.port)
        if url.scheme == "https"
          http.use_ssl = true
          http.ssl_version = :TLSv1_2
        end

        http.start do |connection|
          connection.request req
        end
      end

      def url
        URI(File.join(base_url, "reports"))
      end
    end
  end
end
