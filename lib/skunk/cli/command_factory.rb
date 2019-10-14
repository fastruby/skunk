# frozen_string_literal: true

require 'rubycritic/command_factory'

module Skunk
  module Cli
    class CommandFactory < RubyCritic::CommandFactory
      COMMAND_CLASS_MODES = %i[version help default].freeze

      def self.command_class(mode)
        mode = mode.to_s.split('_').first.to_sym
        if COMMAND_CLASS_MODES.include? mode
          require "skunk/cli/commands/#{mode}"
          Command.const_get(mode.capitalize)
        else
          require 'skunk/cli/commands/default'
          Command::Default
        end
      end
    end
  end
end
