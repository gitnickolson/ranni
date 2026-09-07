# frozen_string_literal: true

module Commands
  module Administrator
    module CustomVoiceChannels
      class CustomVoiceChannels < ParentCommand
        NAME = :custom_voice_channels
        DESCRIPTION = 'Enable or disable custom voice channel creation'
        SUBCOMMANDS = [Enable, Disable].freeze
      end
    end
  end
end
