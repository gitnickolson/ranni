# frozen_string_literal: true

RSpec.describe Utility::Logger do
  subject(:logger) { described_class.instance }

  let(:logging_tool) { instance_double(Ougai::Logger) }

  before do
    described_class.instance_variable_set(:@singleton__instance__, nil)

    allow(Ougai::Logger).to receive(:new).and_return(logging_tool)
    allow(logging_tool).to receive(:level=)
    allow(logging_tool).to receive(:warn)
    allow(logging_tool).to receive(:info)
  end

  describe '#warn' do
    it 'delegates to the logging tool' do
      logger.warn(message: 'warning')

      expect(logging_tool).to have_received(:warn).with('warning')
    end
  end

  describe '#info' do
    it 'delegates to the logging tool' do
      logger.info(message: 'information')

      expect(logging_tool).to have_received(:info).with('information')
    end
  end

  describe '#log_info_and_print' do
    it 'logs and prints the message' do
      expect { logger.log_info_and_print(message: 'hello') }
        .to output(/hello/).to_stdout
      expect(logging_tool).to have_received(:info).with('hello')
    end
  end

  describe '#initialize' do
    it 'creates an Ougai logger with the expected configuration' do
      logger

      expect(Ougai::Logger).to have_received(:new)
        .with($stdout, progname: 'astra')
      expect(logging_tool).to have_received(:level=).with(Logger::WARN)
    end
  end
end
