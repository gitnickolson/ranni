# frozen_string_literal: true

module Commands
  module Administrator
    module VoiceRequirement
      class VoiceRequirement < ParentCommand
        NAME = :voice_requirement
        DESCRIPTION = 'Edit the minimum level needed to join voice chats'
        SUBCOMMANDS = [Set].freeze
      end
    end
  end
end
