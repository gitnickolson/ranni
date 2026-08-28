# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      add_column :ticket_category_id, :string, null: true
      add_column :ticket_log_channel_id, :string, null: true
    end
  end
end
