# frozen_string_literal: true

RSpec.describe Utility::DatabaseManager do
  let(:db_name) { 'service_name_db' }
  let(:test_db_url) { "postgres://localhost/#{db_name}" }
  let(:mock_db) { double(Sequel::Database).as_null_object } # rubocop:disable RSpec/VerifiedDoubles

  before do
    allow(Utility::EnvironmentFetcher).to receive_messages(
      database_url: test_db_url,
      database_name: db_name
    )
    allow(Sequel).to receive(:connect).and_yield(mock_db)
  end

  describe '.create' do
    context 'when the database does not exist' do
      before do
        allow(described_class).to receive(:database_exists?).and_return(false)
      end

      it 'creates the database' do
        expect { described_class.create }.to output(
          "Database #{db_name} successfully created\n"
        ).to_stdout

        expect(mock_db).to have_received(:execute).with("CREATE DATABASE \"#{db_name}\"")
      end
    end

    context 'when the database already exists' do
      before do
        allow(mock_db).to receive(:execute).with("SELECT 1 from pg_database WHERE datname='#{db_name}'").and_return(1)
      end

      it 'sends a corresponding warning' do
        expect { described_class.create }.to output(
          "Database #{db_name} already exists\n"
        ).to_stderr
      end
    end
  end

  describe '.drop' do
    context 'when the database exists' do
      before do
        allow(described_class).to receive(:database_exists?).and_return(true)
      end

      it 'drops the database' do
        expect { described_class.drop }.to output(
          "Database #{db_name} successfully dropped\n"
        ).to_stdout

        expect(mock_db).to have_received(:execute).with("DROP DATABASE \"#{db_name}\" WITH (FORCE)")
      end
    end

    context 'when the database does not exist' do
      before do
        allow(described_class).to receive(:database_exists?).and_return(false)
      end

      it 'sends a corresponding warning' do
        expect { described_class.drop }.to output(
          "Database #{db_name} not found\n"
        ).to_stderr
      end
    end
  end

  describe '.migrate' do
    Sequel.extension :migration
    let(:migrator) { Sequel::Migrator }
    let(:version) { { version: '1' } }
    let(:migrations_dir) { 'migrations' }

    before do
      allow(migrator).to receive(:run)
      allow(Dir).to receive(:exist?).and_return true
      allow(Dir).to receive(:empty?).with(migrations_dir).and_return(false)
    end

    it 'runs migrations to the latest version' do
      expect { described_class.migrate({}) }.to output(
        /Migrating to latest/
      ).to_stdout

      expect(migrator).to have_received(:run)
    end

    it 'runs the migrations to the specified version' do
      expect { described_class.migrate(version) }.to output(
        "Migrating to version 1\nDatabase #{db_name} successfully migrated\n"
      ).to_stdout

      expect(Sequel::Migrator).to have_received(:run)
    end

    context 'when /db directory does not exist' do
      before do
        allow(Dir).to receive(:exist?).and_return false
      end

      it 'does not migrate to any version' do
        expect {        described_class.migrate({}) }.to output(
          "No migration files found\n"
        ).to_stderr
        expect(migrator).not_to have_received(:run)
      end
    end

    context 'when /db directory is empty' do
      before do
        allow(Dir).to receive(:empty?).with(migrations_dir).and_return(true)
      end

      it 'does not migrate to any version' do
        expect { described_class.migrate({}) }.to output(
          "No migration files found\n"
        ).to_stderr
        expect(migrator).not_to have_received(:run)
      end
    end
  end
end
