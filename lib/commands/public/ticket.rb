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
        unless server_service.tickets_enabled?
          return transmitter.error_response(event:, text: t('commands.public.ticket.tickets_disabled'))
        end

        send_ticket_channel_message
        send_ticket_log_channel_message
        transmitter.response(event:, text: t('commands.public.ticket.ticket_successfully_created'),
                             ephemeral: true)
      end

      def send_ticket_channel_message
        channel_name = sanitized_channel_name
        channel = server_service.server.channels.find { it.name == channel_name }

        transmitter.send_message(channel: channel || create_ticket_channel(channel_name),
                                 text: t('commands.public.ticket.ticket_channel_intro',
                                         { user: event.user.mention, topic: event.options['topic'],
                                           date: parsed_date }))
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
        server_service.server.create_channel(channel_name, topic: event.options['topic'], parent: parent_category,
                                                           permission_overwrites:)
      end

      def create_embed_builder
        embed_builder = builder.new(bot:, server_service:, pagination_key:)

        embed_builder.add_title(text: t('commands.public.ticket.embed_heading',
                                        { username: server_service.display_name(user_id: event.user.id, full: true) }))
        embed_builder.add_description(text: "*#{event.options['topic']}*")
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

      def parsed_date
        Utility::TimeParser.parse_to_readable_date(date: server_service.now.to_date)
      end
    end
  end
end
