# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:ranks) do
      primary_key :id
      String :server_id, null: false
      String :role_id, null: false
      Integer :required_level, null: false
    end

    alter_table(:ranks) do
      add_index %i[server_id role_id], name: :unique_role_id_per_server, unique: true
      add_index %i[server_id required_level], name: :unique_required_level_per_server, unique: true
    end
  end
end
