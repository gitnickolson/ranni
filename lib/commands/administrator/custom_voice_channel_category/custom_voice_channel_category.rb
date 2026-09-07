# frozen_string_literal: true

module Commands
  module Administrator
    module CustomVoiceChannelCategory
      class CustomVoiceChannelCategory < ParentCommand
        NAME = :custom_voice_channel_category
        DESCRIPTION = 'Options regarding the category that custom voice channels will appear in'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
