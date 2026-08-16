# frozen_string_literal: true

module Commands
  module Administrator
    module MaxVoiceLevel
      class MaxVoiceLevel < ParentCommand
        NAME = :max_voice_level
        DESCRIPTION = 'Edit the maximum voice level'
        SUBCOMMANDS = [Set].freeze
      end
    end
  end
end
