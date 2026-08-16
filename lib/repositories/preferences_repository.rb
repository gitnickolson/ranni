# frozen_string_literal: true

module Repositories
  class PreferencesRepository
    def initialize(server_id:)
      @server_id = server_id
    end

    def birthday_role_id
      preference.birthday_role_id
    end

    def add_birthday_role(role_id:)
      preference.update(birthday_role_id: role_id)
    end

    def remove_birthday_role
      preference.update(birthday_role_id: nil)
    end

    def welcome_message_channel_id
      preference.welcome_message_channel_id
    end

    def add_welcome_message_channel(channel_id:)
      preference.update(welcome_message_channel_id: channel_id)
    end

    def remove_welcome_message_channel
      preference.update(welcome_message_channel_id: nil)
    end

    def level_up_congratulation_channel_id
      preference.level_up_congratulation_channel_id
    end

    def add_level_up_congratulation_channel(channel_id:)
      preference.update(level_up_congratulation_channel_id: channel_id)
    end

    def remove_level_up_congratulation_channel
      preference.update(level_up_congratulation_channel_id: nil)
    end

    def text_leveling_enabled?
      preference.text_leveling_enabled
    end

    def update_text_leveling_status(turned_on:)
      preference.update(text_leveling_enabled: turned_on)
    end

    def max_text_level
      preference.max_text_level
    end

    def update_max_text_level(level:)
      preference.update(max_text_level: level)
    end

    def max_voice_level
      preference.max_voice_level
    end

    def update_max_voice_level(level:)
      preference.update(max_voice_level: level)
    end

    def timezone
      preference.timezone
    end

    def update_timezone(timezone:)
      preference.update(timezone:)
    end

    def locale
      pp preference.locale
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
    end
  end
end
