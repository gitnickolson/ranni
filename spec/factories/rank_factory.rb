# frozen_string_literal: true

FactoryBot.define do
  to_create(&:save)

  factory(:rank, class: 'Models::Rank') do
    role_id { '123456789987654321' }
    required_level { 22 }
  end
end
