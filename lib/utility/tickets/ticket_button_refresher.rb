# frozen_string_literal: true

module Utility
  module Tickets
    class TicketButtonRefresher
      include Translations::Translatable

      def initialize(server_service:)
        @server_service = server_service
      end

      def call
        return unless server_service.tickets_enabled? && !server_service.ticket_creation_channel.nil?

        ticket_creation_message_id = server_service.preferences_repository.ticket_creation_message_id.to_i
        ticket_creation_message = server_service.ticket_creation_channel.load_message(ticket_creation_message_id)

        return ticket_creation_message_manager.send_full_ticket_message if ticket_creation_message.nil?

        transmitter.update_message(message: ticket_creation_message, text: ticket_creation_message.content,
                                   buttons: [ticket_creation_message_manager.ticket_creation_button])
      end

      private

      attr_reader :server_service

      def ticket_creation_message_manager
        @ticket_creation_message_manager ||= TicketCreationMessageManager.new(server_service:)
      end

      def transmitter
        ::Utility::Messages::MessageTransmitter
      end
    end
  end
end
