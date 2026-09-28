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

        transmitter.update_message(message: ticket_creation_message, text: ticket_creation_message.content,
                                   buttons: [ticket_creation_button])
      end

      private

      attr_reader :server_service

      def ticket_creation_button
        Utility::Messages::Buttons::Button.new(
          custom_id: "ticket_creation_button_#{Time.now.to_i}",
          label: t('utility.tickets.ticket_button_refresher.button_label'),
          style: 3,
          ttl: Utility::Messages::Buttons::Button::INFINITE_TTL
        ) do |event|
          ticket_creator = Utility::Tickets::TicketCreator.new(server_service:, event:)
          ticket_creator.call
        end
      end

      def transmitter
        Utility::Messages::MessageTransmitter
      end
    end
  end
end
