# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:server_preferences) do
      primary_key :id
      string :server_id, null: false
      string :birthday_role_id, null: true
      string :birthday_celebration_channel_id, null: true
      integer :max_text_level, null: true
      integer :max_voice_level, null: true
      string :timezone, default: 'Europe/Berlin'
      string :locale, default: 'DE'
      string :server_color, default: '#8a43ff'
    end

    alter_table(:server_preferences) do
      add_index :server_id, name: :unique_preferences_per_server, unique: true
    end
  end
end
