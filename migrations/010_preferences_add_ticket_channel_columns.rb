# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      add_column :ticket_category_id, String, null: true
      add_column :ticket_log_channel_id, String, null: true
      add_column :tickets_enabled, :boolean, default: false, null: false
    end
  end
end
