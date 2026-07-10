# frozen_string_literal: true

RSpec.describe Config::ZeitwerkInitializer do
  let(:loader) { instance_double(Zeitwerk::Loader) }
  let(:lib_path) { File.expand_path('../../lib', __dir__) } 

  before do
    allow(Zeitwerk::Loader).to receive(:new).and_return(loader)
    allow(loader).to receive(:push_dir)
    allow(loader).to receive(:setup)
  end

  describe '.call' do
    it 'registers the lib directory on the loader' do
      described_class.call

      expect(loader).to have_received(:push_dir).with(lib_path)
    end

    it 'sets up autoloading on that same loader instance' do
      described_class.call

      expect(loader).to have_received(:push_dir).with(lib_path).ordered
      expect(loader).to have_received(:setup).ordered
    end
  end
end