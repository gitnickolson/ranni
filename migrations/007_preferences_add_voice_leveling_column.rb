# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      add_column :voice_leveling_enabled, :boolean, default: false, null: false
    end
  end
end
