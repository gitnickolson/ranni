# frozen_string_literal: true

module Commands
  module Public
    class Ticket < Command
      NAME = :ticket
      DESCRIPTION = 'Create a ticket to receive support'
      PARAMETERS = [{ type: :string, name: :topic, required: true,
                      description: 'Enter the topic of your ticket or the reason for the ticket creation' }].freeze

      private

      def command_action
        ticket_creator = Utility::Tickets::TicketCreator.new(server_service:, event:, topic: event.options['topic'])
        ticket_creator.call
      end
    end
  end
end
