# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      add_column :custom_voice_channel_category_id, String, null: true
    end
  end
end
