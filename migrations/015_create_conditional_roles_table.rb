# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:conditional_roles) do
      primary_key :id
      String :server_id, null: false
      String :role_id, null: false
      String :condition, size: 100, null: false
    end

    alter_table(:conditional_roles) do
      add_index %i[server_id role_id], name: :unique_conditional_role_id_per_server, unique: true
    end
  end
end
