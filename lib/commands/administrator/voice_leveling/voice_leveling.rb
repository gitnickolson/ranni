# frozen_string_literal: true

module Commands
  module Administrator
    module VoiceLeveling
      class VoiceLeveling < ParentCommand
        NAME = :voice_leveling
        DESCRIPTION = 'Enable or disable voice leveling'
        SUBCOMMANDS = [Enable, Disable].freeze
      end
    end
  end
end
