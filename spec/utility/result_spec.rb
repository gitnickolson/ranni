# frozen_string_literal: true

RSpec.describe Utility::Result do
  describe '.ok' do
    let(:result) { described_class.ok(value: value) }
    let(:value) { 'some_value' }

    it 'returns a Result instance' do
      expect(result).to be_a(described_class)
    end

    it 'is ok' do
      expect(result.ok?).to be true
    end

    it 'is not a failure' do
      expect(result.failure?).to be false
    end

    it 'exposes the given value' do
      expect(result.value).to eq(value)
    end

    context 'when no value is provided' do
      subject(:result) { described_class.ok }

      it 'defaults value to nil' do
        expect(result.value).to be_nil
      end
    end
  end

  describe '.failure' do
    let(:result) { described_class.failure(error: error) }
    let(:error) { 'something went wrong' }

    it 'returns a Result instance' do
      expect(result).to be_a(described_class)
    end

    it 'is a failure' do
      expect(result.failure?).to be true
    end

    it 'is not ok' do
      expect(result.ok?).to be false
    end

    it 'exposes the error as value' do
      expect(result.value).to eq(error)
    end

    context 'when no error is provided' do
      subject(:result) { described_class.failure }

      it 'defaults value to nil' do
        expect(result.value).to be_nil
      end
    end
  end
end
