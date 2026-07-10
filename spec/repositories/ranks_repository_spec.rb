# frozen_string_literal: true

RSpec.describe Repositories::RanksRepository do
  describe '.all' do
    let!(:high_rank) { create(:rank, role_id: '111', required_level: 50) }
    let!(:low_rank) { create(:rank, role_id: '222', required_level: 10) }
    let!(:mid_rank) { create(:rank, role_id: '333', required_level: 30) }

    it 'returns all ranks ordered by required_level ascending' do
      result = described_class.all

      expect(result).to eq([low_rank, mid_rank, high_rank])
    end
  end

  describe '.find_by_role' do
    let(:role_id) { '123456789987654321' }
    let!(:rank) { create(:rank, role_id:, required_level: 22) }

    it 'returns the rank matching the given role_id' do
      expect(described_class.find_by_role(role_id:)).to eq(rank)
    end

    it 'coerces a non-string role_id to a string before matching' do
      expect(described_class.find_by_role(role_id: role_id.to_i)).to eq(rank)
    end

    it 'returns nil when no rank matches the given role_id' do
      expect(described_class.find_by_role(role_id: 'nonexistent')).to be_nil
    end
  end

  describe '.find_by_level' do
    let(:required_level) { 22 }
    let!(:rank) { create(:rank, required_level:) }

    it 'returns the rank matching the given required_level' do
      expect(described_class.find_by_level(required_level:)).to eq(rank)
    end

    it 'returns nil when no rank matches the given required_level' do
      expect(described_class.find_by_level(required_level: 999)).to be_nil
    end
  end

  describe '.create' do
    let(:role_id) { '123456789987654321' }
    let(:required_level) { 22 }

    it 'creates a rank with the given role_id and required_level' do
      described_class.create(role_id:, required_level:)

      created_rank = Models::Rank.first
      expect(created_rank.role_id).to eq(role_id)
      expect(created_rank.required_level).to eq(required_level)
    end

    it 'coerces a non-string role_id to a string before storing' do
      described_class.create(role_id: role_id.to_i, required_level:)

      expect(Models::Rank.first.role_id).to eq(role_id)
    end
  end

  describe '.delete' do
    context 'when role_id is already a string' do
      let(:role_id) { '123456789987654321' }

      before { create(:rank, role_id:, required_level: 22) }

      it 'deletes the rank with the matching role_id' do
        expect { described_class.delete(role_id:) }.to change(Models::Rank, :count).from(1).to(0)
      end
    end
  end
end
