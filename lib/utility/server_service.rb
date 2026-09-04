# frozen_string_literal: true

module Utility
  class ServerService
    def initialize(bot:, server_id:)
      @bot = bot
      @server_id = server_id
    end

    attr_reader :server_id

    def server
      bot.servers[server_id]
    end

    def member_from(identifier:, nickname_check: false)
      server.members.find do |member|
        matching_id?(identifier, member) || matching_name_identifier?(identifier, member, nickname_check:)
      end
    end

    def display_name(user_id:, full: false)
      member = member_from(identifier: user_id)

      return member.display_name unless full

      member.display_name ? "#{member.display_name} (#{member.username})" : member.username
    end

    def user_ids
      server.members.map(&:id)
    end

    def channel_from_id(channel_id:)
      server.channels.find { it.id == channel_id.to_i }
    end

    def role_from_id(role_id:)
      server.roles.find { |role| role.id == role_id.to_i }
    end

    def now
      timezone.now
    end

    def timezone
      TZInfo::Timezone.get(preferences_repository.timezone)
    end

    def locale
      preferences_repository.locale.downcase
    end

    def server_color
      preferences_repository.server_color
    end

    def max_level
      preferences_repository.max_level
    end

    def voice_chat_level_requirement
      preferences_repository.voice_chat_level_requirement
    end

    def text_leveling_enabled?
      preferences_repository.text_leveling_enabled?
    end

    def voice_leveling_enabled?
      preferences_repository.voice_leveling_enabled?
    end

    def tickets_enabled?
      preferences_repository.tickets_enabled?
    end

    def suggestion_channel
      channel_from_id(channel_id: preferences_repository.suggestion_channel_id)
    end

    def level_up_congratulation_channel
      channel_from_id(channel_id: preferences_repository.level_up_congratulation_channel_id)
    end

    def welcome_message_channel
      channel_from_id(channel_id: preferences_repository.welcome_message_channel_id)
    end

    def ticket_category
      channel_from_id(channel_id: preferences_repository.ticket_category_id)
    end

    def ticket_log_channel
      channel_from_id(channel_id: preferences_repository.ticket_log_channel_id)
    end

    def birthday_celebration_channel
      channel_from_id(channel_id: preferences_repository.birthday_celebration_channel_id)
    end

    def birthday_role
      roles_repository.role_from_id(role_id: preferences_repository.birthday_role_id)
    end

    private

    attr_reader :bot

    def matching_id?(identifier, member)
      identifier == member.id.to_s || identifier == member.id
    end

    def matching_name_identifier?(identifier, member, nickname_check: false)
      [
        identifier == member.mention,
        identifier.to_s.downcase == member.username.downcase,
        nickname_check && identifier == member.display_name
      ].any?
    end

    def preferences_repository
      @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
    end

    def roles_repository
      @roles_repository ||= Repositories::RolesRepository.new(server_service: self)
    end
  end
end
