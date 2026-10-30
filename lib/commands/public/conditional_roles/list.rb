# frozen_string_literal: true

module Commands
  module Public
    module ConditionalRoles
      class List < Subcommand
        NAME = :list
        DESCRIPTION = 'Retrieve a list of all conditional roles'
        MAX_PAGE_ITEMS = 15

        private

        def command_action
          embed_builder = create_embed_builder
          transmitter.embed_response(event:, embed_builder:)
        end

        def create_embed_builder
          embed_builder = builder.new(server_service:, pagination_key:, max_page_items: MAX_PAGE_ITEMS)

          embed_builder.update_fields(fields:)
          embed_builder.add_title(text: t('commands.public.conditional_roles.list.list_title',
                                          { server_name: server.name }))
          embed_builder.change_footer(
            text: t('commands.public.conditional_roles.list.list_length',
                    { conditional_roles_count: conditional_roles.length }),
            append_to_default: true
          )
        end

        def fields
          conditional_roles.map do |conditional_role|
            role_mention = roles_repository.role_from_id(role_id: conditional_role.role_id.to_i).mention.to_s
            field.new(value: "#{t('commands.public.conditional_roles.list.list_entry_title',
                                  { role: role_mention })}\n#{conditional_role.condition}")
          end
        end

        def conditional_roles
          @conditional_roles ||= conditional_roles_repository.all
        end

        def conditional_roles_repository
          Repositories::ConditionalRolesRepository.new(server_service:)
        end

        def roles_repository
          @roles_repository ||= Repositories::RolesRepository.new(server_service:)
        end
      end
    end
  end
end
