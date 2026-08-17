# frozen_string_literal: true

Sequel.migration do
  change do
    rename_table(:text_levels, :levels)

    alter_table(:levels) do
      drop_index %i[server_id user_id], name: :unique_level_per_server
      add_index %i[server_id user_id], name: :unique_level_per_server, unique: true
    end
  end
end
