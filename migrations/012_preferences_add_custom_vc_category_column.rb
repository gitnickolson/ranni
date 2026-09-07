# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      add_column :custom_voice_channel_category_id, String, null: true
      add_column :custom_voice_channels_enabled, :boolean, default: false, null: false
    end
  end
end
