# frozen_string_literal: true

module Commands
  module Administrator
    module Ranks
      class List < Subcommand
        NAME = :list
        DESCRIPTION = 'Rufe eine Liste aller Ränge ab'

        private

        def command_action
          embed_builder = create_embed_builder
          transmitter.embed_response(event:, embed_builder:)
        end

        def create_embed_builder
          embed_builder = builder.new(bot:, pagination_key:, max_page_items: 20)

          embed_builder.update_fields(fields:)
          embed_builder.add_title(text: "Ränge auf #{server.name}")
          embed_builder.change_footer(text: "#{ranks.length} Ränge", append_to_default: true)
        end

        def fields
          ranks.map do |rank|
            field.new(name: "Level #{rank.required_level}",
                      value: server_accessor.role_from_id(role_id: rank.role_id.to_i).mention.to_s)
          end
        end

        def ranks
          Repositories::RanksRepository.all
        end

        def server_accessor
          @server_accessor ||= Utility::ServerAccessor.new(bot:, server_id:)
        end
      end
    end
  end
end
