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
          embed_builder = builder.new(bot:, server_service:, pagination_key:, max_page_items: 20)

          embed_builder.update_fields(fields:)
          embed_builder.add_title(text: t('commands.administrator.rank.list_title', { server_name: server.name }))
          embed_builder.change_footer(text: t('commands.administrator.rank.list_length', { ranks_count: ranks.length }),
                                      append_to_default: true)
        end

        def fields
          ranks.map do |rank|
            field.new(name: t('commands.administrator.rank.list_entry_title', { level: rank.required_level }),
                      value: roles_repository.role_from_id(role_id: rank.role_id.to_i).mention.to_s)
          end
        end

        def ranks
          ranks_repository.all
        end

        def ranks_repository
          @ranks_repository ||= Repositories::RanksRepository.new(server_service:)
        end

        def roles_repository
          @roles_repository ||= Repositories::RolesRepository.new(server_service:)
        end
      end
    end
  end
end
