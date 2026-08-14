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

    def now
      current_timezone.now
    end

    def current_timezone
      TZInfo::Timezone.get(preferences_repository.timezone)
    end

    def locale
      preferences_repository.locale.downcase.capitalize
    end

    def default_color_code
      preferences_repository.server_color
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
  end
end
