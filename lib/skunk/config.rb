# frozen_string_literal: true

module Skunk
  # Utility module for format validation
  module FormatValidator
    # Supported output formats
    SUPPORTED_FORMATS = %i[json html console].freeze

    # Check if a format is supported
    # @param format [Symbol] Format to check
    # @return [Boolean] True if format is supported
    def self.supported_format?(format)
      SUPPORTED_FORMATS.include?(format)
    end

    # Get all supported formats
    # @return [Array<Symbol>] All supported formats
    def self.supported_formats
      SUPPORTED_FORMATS.dup
    end
  end

  # Configuration class for Skunk that supports formats
  # Similar to RubyCritic::Configuration but focused only on Skunk's needs
  class Configuration
    # Default format
    DEFAULT_FORMAT = :console

    def initialize
      @formats = [DEFAULT_FORMAT]
    end

    def set(options = {})
      self.formats = options[:formats] if options.key?(:formats)
    end

    # Get the configured formats
    # @return [Array<Symbol>] Array of format symbols
    attr_reader :formats

    # Set the formats with validation
    # @param format_list [Array<Symbol>, Symbol] Format(s) to set
    def formats=(format_list)
      format_array = Array(format_list)
      @formats = format_array.select { |format| FormatValidator.supported_format?(format) }
      @formats = [DEFAULT_FORMAT] if @formats.empty?
    end

    # Add a format to the existing list
    # @param format [Symbol] Format to add
    def add_format(format)
      return unless FormatValidator.supported_format?(format)

      @formats << format unless @formats.include?(format)
    end

    # Remove a format from the list
    # @param format [Symbol] Format to remove
    def remove_format(format)
      @formats.delete(format)
      @formats = [DEFAULT_FORMAT] if @formats.empty?
    end

    # Check if a format is supported
    # @param format [Symbol] Format to check
    # @return [Boolean] True if format is supported
    def supported_format?(format)
      FormatValidator.supported_format?(format)
    end

    # Get all supported formats
    # @return [Array<Symbol>] All supported formats
    def supported_formats
      FormatValidator.supported_formats
    end

    # Reset to default configuration
    def reset
      @formats = [DEFAULT_FORMAT]
    end
  end

  # Config module that delegates to Configuration instance
  # Similar to RubyCritic::Config pattern
  module Config
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.set(options = {})
      configuration.set(options)
    end

    def self.method_missing(method, *args, &block)
      if configuration.respond_to?(method)
        configuration.public_send(method, *args, &block)
      else
        super
      end
    end

    def self.respond_to_missing?(symbol, include_private = false)
      configuration.respond_to?(symbol, include_private) || super
    end
  end
end
