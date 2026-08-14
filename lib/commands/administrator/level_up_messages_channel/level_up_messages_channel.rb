# frozen_string_literal: true

module Commands
  module Administrator
    module LevelUpMessagesChannel
      class LevelUpMessagesChannel < ParentCommand
        NAME = :level_up_messages_channel
        DESCRIPTION = 'Optionen zum Level-Up Nachrichten Kanal'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
