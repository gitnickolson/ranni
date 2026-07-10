# frozen_string_literal: true

RSpec.describe Config::EnvironmentInitializer do
  let(:project_root) { File.expand_path('../../', __dir__) }
  let(:logger) { instance_double(Utility::Logger) }

  before do
    allow(Dotenv).to receive(:load)
    allow(Utility::Logger).to receive(:instance).and_return(logger)
    allow(logger).to receive(:log_info_and_print)
  end

  describe '.call' do
    context 'when environment is set to "production"' do
      before { allow(ENV).to receive(:[]).with('ENV').and_return('production') }

      it 'loads the production .env file' do
        described_class.call

        expect(Dotenv).to have_received(:load).with(File.join(project_root, '.env'))
      end

      it 'delegates the loaded path to the logger' do
        expected_path = File.join(project_root, '.env')
        described_class.call

        expect(logger).to have_received(:log_info_and_print).with(message: "Loading env from: #{expected_path}")
      end
    end

    context 'when environment is not explicitly set' do
      before { allow(ENV).to receive(:[]).with('ENV').and_return(nil) }

      it 'falls back to the test .env file' do
        described_class.call

        expect(Dotenv).to have_received(:load).with(File.join(project_root, '.env.test'))
      end

      it 'delegates the loaded path to the logger' do
        expected_path = File.join(project_root, '.env.test')
        described_class.call

        expect(logger).to have_received(:log_info_and_print).with(message: "Loading env from: #{expected_path}")
      end
    end
  end
end
