# frozen_string_literal: true

module Repositories
  class PreferencesRepository
    def initialize(server_id:)
      @server_id = server_id
    end

    def birthday_role_id
      preference.birthday_role_id
    end

    def set_birthday_role(role_id:)
      preference.update(birthday_role_id: role_id)
    end

    def birthday_celebration_channel_id
      preference.birthday_celebration_channel_id
    end

    def set_birthday_celebration_channel_id(channel_id:)
      preference.update(birthday_celebration_channel_id: channel_id)
    end

    def welcome_message_channel_id
      preference.welcome_message_channel_id
    end

    def set_welcome_message_channel(channel_id:)
      preference.update(welcome_message_channel_id: channel_id)
    end

    def ticket_category_id
      preference.ticket_category_id
    end

    def set_ticket_category(category_id:)
      preference.update(ticket_category_id: category_id)
    end

    def custom_voice_channels_enabled?
      preference.custom_voice_channels_enabled
    end

    def set_custom_voice_channels_creation(enabled:)
      preference.update(custom_voice_channels_enabled: enabled)
    end

    def custom_voice_channel_category_id
      preference.custom_voice_channel_category_id
    end

    def set_custom_voice_channel_category(category_id:)
      preference.update(custom_voice_channel_category_id: category_id)
    end

    def suggestion_channel_id
      preference.suggestion_channel_id
    end

    def set_suggestion_channel(channel_id:)
      preference.update(suggestion_channel_id: channel_id)
    end

    def ticket_log_channel_id
      preference.ticket_log_channel_id
    end

    def set_ticket_log_channel(channel_id:)
      preference.update(ticket_log_channel_id: channel_id)
    end

    def level_up_congratulation_channel_id
      preference.level_up_congratulation_channel_id
    end

    def set_level_up_congratulation_channel(channel_id:)
      preference.update(level_up_congratulation_channel_id: channel_id)
    end

    def tickets_enabled?
      preference.tickets_enabled
    end

    def set_ticket_creation(enabled:)
      preference.update(tickets_enabled: enabled)
    end

    def voice_leveling_enabled?
      preference.voice_leveling_enabled
    end

    def set_voice_leveling(enabled:)
      preference.update(voice_leveling_enabled: enabled)
    end

    def text_leveling_enabled?
      preference.text_leveling_enabled
    end

    def set_text_leveling(enabled:)
      preference.update(text_leveling_enabled: enabled)
    end

    def max_level
      preference.max_level
    end

    def update_max_level(level:)
      preference.update(max_level: level)
    end

    def voice_chat_level_requirement
      preference.voice_chat_level_requirement
    end

    def set_voice_chat_level_requirement(level:)
      preference.update(voice_chat_level_requirement: level)
    end

    def timezone
      preference.timezone
    end

    def update_timezone(timezone:)
      preference.update(timezone:)
    end

    def locale
      preference.locale
    end

    def update_locale(locale:)
      preference.update(locale:)
    end

    def server_color
      preference.server_color
    end

    def update_server_color(color_code:)
      preference.update(server_color: color_code)
    end

    private

    attr_reader :server_id

    def preference
      @preference ||= Models::ServerPreferences.find_or_create(server_id: server_id.to_s)
      @preference.reload
    end
  end
end
