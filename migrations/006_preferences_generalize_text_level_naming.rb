# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      rename_column :max_text_level, :max_level
      drop_column :max_voice_level
    end
  end
end
