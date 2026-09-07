# frozen_string_literal: true

module Commands
  module Public
    class Vc < Command
      NAME = :vc
      DESCRIPTION = 'Create a configurable custom voice channel'

      private

      def command_action
        unless server_service.custom_voice_channels_enabled?
          return transmitter.error_response(event:, text: t('commands.public.vc.custom_voice_channels_disabled'))
        end

        channel = create_voice_channel
        transmitter.response(event:, text: t('commands.public.vc.channel_successfully_created',
                                             { channel: channel.mention }),
                             ephemeral: true)

        Utility::EmptyChannelDeleter.call(channel:)
      end

      def create_voice_channel
        parent_category = server_service.custom_voice_channel_category
        server_service.server.create_channel(sanitized_channel_name, 2, parent: parent_category, permission_overwrites:)
      end

      def permission_overwrites
        user_permission_accepts = Discordrb::Permissions.new
        user_permission_accepts.can_read_messages = true
        user_permission_accepts.can_send_messages = true
        user_permission_accepts.can_speak = true
        user_permission_accepts.can_connect = true
        user_permission_accepts.can_manage_channels = true
        user_permission_accepts.can_move_members = true

        [Discordrb::Overwrite.new(event.user, allow: user_permission_accepts, deny: nil)]
      end

      def sanitized_channel_name
        "#{event.user.username.downcase.gsub(/[^a-z0-9\-_]/, '-').squeeze('-')}-vc"
      end
    end
  end
end
