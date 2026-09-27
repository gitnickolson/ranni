# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      add_column :ticket_creation_channel_id, String, null: true
      add_column :ticket_creation_message_id, String, null: true
    end
  end
end
