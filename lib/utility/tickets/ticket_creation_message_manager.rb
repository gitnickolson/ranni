# frozen_string_literal: true

module Utility
  module Tickets
    class TicketCreationMessageManager
      include Translations::Translatable

      def initialize(server_service:)
        @server_service = server_service
      end

      def send_full_ticket_message
        channel = server_service.ticket_creation_channel

        message = ::Utility::Messages::MessageTransmitter.send_message(
          channel:,
          text: t('utility.tickets.ticket_creation_message_creator.intro_text'),
          buttons: [ticket_creation_button]
        )

        server_service.preferences_repository.set_ticket_creation_message(message_id: message.id)
      end

      def delete_ticket_creation_message
        channel = server_service.ticket_creation_channel
        message_id = server_service.preferences_repository.ticket_creation_message_id
        message = channel.load_message(message_id)

        return if message.nil?

        ::Utility::Messages::Buttons::ButtonRegistry.instance.unregister(
          custom_id: /\Aticket_creation_button_#{server_service.server.id}_\d+\z/
        )

        channel.delete_message(message)
      end

      def ticket_creation_button
        Utility::Messages::Buttons::Button.new(
          custom_id: "ticket_creation_button_#{server_service.server.id}_#{Time.now.to_i}",
          label: t('utility.tickets.ticket_creation_message_creator.button_label'),
          style: 4,
          ttl: Utility::Messages::Buttons::Button::INFINITE_TTL
        ) do |event|
          ticket_creator = Utility::Tickets::TicketCreator.new(server_service:, event:)
          ticket_creator.call
        end
      end

      private

      attr_reader :server_service
    end
  end
end
