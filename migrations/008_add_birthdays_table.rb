# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:birthdays) do
      primary_key :id
      String :user_id, null: false
      Date :date, null: false
    end

    alter_table(:birthdays) do
      add_index :user_id, name: :unique_user_id, unique: true
    end
  end
end
