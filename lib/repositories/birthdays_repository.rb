# frozen_string_literal: true

module Repositories
  class BirthdaysRepository
    def initialize(server_service:)
      @server_service = server_service
    end

    def all(date: nil, on_server: false)
      dataset = Models::Birthday.order(:date)
      if date
        dataset = dataset.where(Sequel.lit('EXTRACT(MONTH FROM date) = ? AND EXTRACT(DAY FROM date) = ?',
                                           date.month,
                                           date.day))
      end

      return dataset.all unless on_server

      dataset.all.select { |birthday| user_on_server?(birthday.user_id) }
    end

    def get_for(user_id:)
      Models::Birthday.where(user_id: user_id.to_s).first
    end

    def update_or_create(user_id:, date:)
      Models::Birthday.update_or_create(user_id: user_id.to_s) { |birthday| birthday.date = date }
    end

    def delete(user_id:)
      Models::Birthday.where(user_id: user_id.to_s).delete
    end

    private

    attr_reader :server_service

    def user_on_server?(user_id)
      return true if server_service.member_from(identifier: user_id)

      false
    end

    def server
      server_service.server
    end
  end
end
