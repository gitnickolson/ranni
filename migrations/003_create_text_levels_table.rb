# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:text_levels) do
      primary_key :id
      String :server_id, null: false
      String :user_id, null: false
      Integer :numeric, default: 0, null: false
      Integer :experience_points, default: 0, null: false
    end

    alter_table(:server_preferences) do
      add_index %i[server_id user_id], name: :unique_level_per_server, unique: true
    end
  end
end
