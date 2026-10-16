# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:server_preferences) do
      set_column_default :locale, 'en'
    end
  end
end
