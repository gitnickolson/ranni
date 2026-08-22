# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      add_column :voice_chat_level_requirement, :integer, default: 0, null: false
    end
  end
end
