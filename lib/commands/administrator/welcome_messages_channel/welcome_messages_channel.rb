# frozen_string_literal: true

module Commands
  module Administrator
    module WelcomeMessagesChannel
      class WelcomeMessagesChannel < ParentCommand
        NAME = :welcome_messages_channel
        DESCRIPTION = 'Optionen zum Willkommensnachrichten-Kanal'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
