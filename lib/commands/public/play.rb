module Commands
  module Public
    class Play < Command
      NAME = :play
      DESCRIPTION = 'Play a Song'
      PARAMETERS = [{name: :song, required: true, description: 'Song name or YT-URL' }].freeze

      private

      def command_action
        parameter_song = event.options['song']
        embed_builder = create_embed_builder(parameter_song)
        transmitter.embed_response(event:, embed_builder:)
      end
    end
  end
end
