# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:ranks) do
      primary_key :id
      String :role_id, null: false
      Integer :required_level, null: false
    end

    alter_table(:ranks) do
      add_index :role_id, name: :unique_role_id, unique: true
      add_index :required_level, name: :unique_required_level, unique: true
    end
  end
end
