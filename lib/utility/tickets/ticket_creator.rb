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
        channel_name = sanitized_channel_name
        channel = server_service.server.channels.find { it.name == channel_name }

        return button_creation_message(channel, channel_name) if topic.nil?

        command_creation_message(channel, channel_name)
      end

      def sanitized_channel_name
        "#{event.user.username.downcase.gsub(/[^a-z0-9\-_]/, '-').squeeze('-')}-ticket"
      end

      def send_ticket_log_channel_message
        channel = server_service.ticket_log_channel

        return if channel.nil?

        embed_builder = create_embed_builder
        transmitter.send_embed_message(channel:, embed_builder:)
      end

      def create_ticket_channel(channel_name)
        parent_category = server_service.ticket_category
        server_service.server.create_channel(channel_name, topic:, parent: parent_category,
                                                           permission_overwrites:)
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

      def button_creation_message(channel, channel_name)
        transmitter.send_message(channel: channel || create_ticket_channel(channel_name),
                                 text: t('utility.tickets.ticket_creator.ticket_channel_intro_without_topic',
                                         { user: event.user.mention, date: parsed_date }))
      end

      def command_creation_message(channel, channel_name)
        transmitter.send_message(channel: channel || create_ticket_channel(channel_name),
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
