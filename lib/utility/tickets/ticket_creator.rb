# frozen_string_literal: true

module Utility
  module Tickets
    class TicketCreator
      include Translations::Translatable

      def initialize(server_service:, event:, topic: nil)
        @server_service = server_service
        @event = event
        @topic = topic
      end

      def call
        unless server_service.tickets_enabled?
          return transmitter.error_response(event:, text: t('utility.tickets.ticket_creator.tickets_disabled'))
        end

        send_ticket_channel_message
        send_ticket_log_channel_message
        transmitter.response(event:, text: t('utility.tickets.ticket_creator.ticket_successfully_created'),
                             ephemeral: true)
      end

      private

      attr_reader :server_service, :event, :topic

      def send_ticket_channel_message
        channel = find_or_create_ticket_channel

        return button_creation_message(channel) if topic.nil?

        command_creation_message(channel)
      end

      def send_ticket_log_channel_message
        channel = server_service.ticket_log_channel

        return if channel.nil?

        embed_builder = create_embed_builder
        transmitter.send_embed_message(channel:, embed_builder:)
      end

      def find_or_create_ticket_channel
        parent_category = server_service.ticket_category

        channel = server_service.server.channels.find do |channel|
          next unless channel.name == sanitized_channel_name
          next channel if channel.parent_id == parent_category&.id

          nil
        end

        return channel unless channel.nil?

        server_service.server.create_channel(sanitized_channel_name, topic:, parent: parent_category,
                                                                     permission_overwrites:)
      end

      def sanitized_channel_name
        "#{event.user.username.downcase.gsub(/[^a-z0-9\-_]/, '-').squeeze('-')}-ticket-#{day_string}"
      end

      def day_string
        "#{server_service.now.day}-#{server_service.now.month}-#{server_service.now.year}"
      end

      def create_embed_builder
        embed_builder = ::Utility::Messages::Embeds::EmbedBuilder.new(server_service:, pagination_key:)

        embed_builder.add_title(text: t('utility.tickets.ticket_creator.embed_heading',
                                        { username: server_service.display_name(user_id: event.user.id, full: true) }))
        embed_builder.add_description(text: "*#{topic || t('utility.tickets.ticket_creator.no_topic_specified')}*")
        embed_builder.add_thumbnail(thumbnail_url: event.user.avatar_url)
        embed_builder.change_footer(text: parsed_date)
      end

      def permission_overwrites
        [Discordrb::Overwrite.new(server_service.server.everyone_role, **everyone_permissions),
         Discordrb::Overwrite.new(event.user, **user_permissions)]
      end

      def everyone_permissions
        everyone_permission_denials = Discordrb::Permissions.new
        everyone_permission_denials.can_read_messages = true
        everyone_permission_denials.can_send_messages = true

        everyone_permission_accepts = Discordrb::Permissions.new
        everyone_permission_accepts.can_read_message_history = true

        { allow: everyone_permission_accepts, deny: everyone_permission_denials }
      end

      def user_permissions
        user_permission_accepts = Discordrb::Permissions.new
        user_permission_accepts.can_read_messages = true
        user_permission_accepts.can_send_messages = true

        { allow: user_permission_accepts, deny: nil }
      end

      def button_creation_message(channel)
        transmitter.send_message(channel:,
                                 text: t('utility.tickets.ticket_creator.ticket_channel_intro_without_topic',
                                         { user: event.user.mention, date: parsed_date }))
      end

      def command_creation_message(channel)
        transmitter.send_message(channel:,
                                 text: t('utility.tickets.ticket_creator.ticket_channel_intro',
                                         { user: event.user.mention, topic:,
                                           date: parsed_date }))
      end

      def parsed_date
        Utility::TimeParser.parse_to_readable_date(date: server_service.now.to_date)
      end

      def transmitter
        ::Utility::Messages::MessageTransmitter
      end

      def pagination_key
        "#ticket_creator-#{event.user.id}-#{Time.now.to_i}"
      end
    end
  end
end
