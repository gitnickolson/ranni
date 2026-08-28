# frozen_string_literal: true

module Commands
  module Administrator
    module TicketCategory
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set a category for tickets'
        PARAMETERS = [{ type: :channel, name: :category, required: true,
                        description: 'Choose the category that ticket channels will appear in' }].freeze

        private

        def command_action
          category_id = event.options['category']
          channel = server_service.channel_from_id(channel_id: category_id)

          unless channel.type == 4
            return transmitter.error_response(event:,
                                              text: t('commands.administrator.ticket_category.set.not_a_category'))
          end

          preferences_repository.add_ticket_category(category_id:)
          transmitter.response(event:,
                               text: t('commands.administrator.ticket_category.set.category_successfully_set',
                                       { category: channel.mention }))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
