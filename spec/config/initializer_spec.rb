# frozen_string_literal: true

RSpec.describe Config::Initializer do
  before do
    allow(Config::ZeitwerkInitializer).to receive(:call)
    allow(Config::EnvironmentInitializer).to receive(:call)
  end

  describe '.call' do
    it 'initializes Zeitwerk autoloading' do
      described_class.call

      expect(Config::ZeitwerkInitializer).to have_received(:call)
    end

    it 'initializes the environment' do
      described_class.call

      expect(Config::EnvironmentInitializer).to have_received(:call)
    end

    it 'initializes Zeitwerk before the environment' do
      described_class.call

      expect(Config::ZeitwerkInitializer).to have_received(:call).ordered
      expect(Config::EnvironmentInitializer).to have_received(:call).ordered
    end
  end
end
