# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:server_preferences) do
      primary_key :id
      String :server_id, null: false
      String :birthday_role_id, null: true
      String :birthday_celebration_channel_id, null: true
      String :welcome_message_channel_id, null: true
      String :level_up_congratulation_channel_id, null: true
      Boolean :text_leveling_enabled, default: false, null: false
      Integer :max_text_level, default: 100, null: false
      Integer :max_voice_level, default: 100, null: false
      String :timezone, default: 'Europe/Berlin', null: false
      String :locale, default: 'DE', null: false
      String :server_color, default: '#8a43ff', null: false
    end

    alter_table(:server_preferences) do
      add_index :server_id, name: :unique_preferences_per_server, unique: true
    end
  end
end
