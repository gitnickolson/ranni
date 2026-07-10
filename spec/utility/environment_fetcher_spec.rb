# frozen_string_literal: true

RSpec.describe Utility::EnvironmentFetcher do
  describe '.postgres_url' do
    it 'fetches POSTGRES_URL from ENV' do
      allow(ENV).to receive(:fetch).with('POSTGRES_URL').and_return('postgres://localhost')

      expect(described_class.postgres_url).to eq('postgres://localhost')
    end
  end

  describe '.database_name' do
    it 'fetches POSTGRES_DB from ENV' do
      allow(ENV).to receive(:fetch).with('POSTGRES_DB').and_return('test_db')

      expect(described_class.database_name).to eq('test_db')
    end
  end
end
