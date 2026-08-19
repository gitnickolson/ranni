# frozen_string_literal: true

require 'csv'
require 'time'
require 'date'

module Events
  class BirthdayCelebration
    def initialize(server_service:)
      @server_service = server_service
      @previous_affected_members = []
    end

    def call
      Thread.new { birthday_management_loop }
    end

    private

    attr_accessor :previous_affected_members
    attr_reader :server_service

    def birthday_management_loop
      loop do
        affected_members = find_affected_members

        sleep seconds_until_midnight

        remove_birthday_role(previous_affected_members) if previous_affected_members.any? && birthday_role_set?

        @previous_affected_members = affected_members
        next if affected_members.empty?

        birthday_actions(affected_members)
      rescue StandardError => e
        logger.error(message: "Error in Birthday#birthday_management_loop: #{e.message}")
      end
    end

    def birthday_actions(affected_members)
      add_birthday_role(affected_members) if birthday_role_set?
      congratulate(affected_members) unless server_service.birthday_celebration_channel.nil?
    end

    def find_affected_members
      birthdays = birthdays_repository.all(date: server_service.now.to_date + 1)
      birthdays.map { server_service.member_from(identifier: it.user_id) }.compact
    end

    def add_birthday_role(affected_members)
      affected_members.each { it.add_role(server_service.birthday_role.id) }
    end

    def remove_birthday_role(affected_members)
      affected_members.each { it.remove_role(server_service.birthday_role.id) }
    end

    def congratulate(members)
      message = members.length > 1 ? multiple_members_message(members) : single_member_message(members)

      Utility::Messages::MessageTransmitter.send_message(channel: celebration_channel, text: message)
    end

    def seconds_until_midnight
      (next_midnight_date_time - server_service.now).to_i
    end

    def next_midnight_date_time
      tomorrow = server_service.now + (60 * 60 * 24)
      server_service.current_timezone.local_time(tomorrow.year, tomorrow.month, tomorrow.day, 0, 5)
    end

    def single_member_message(birthday_members)
      t('events.birthday_celebration.single_member_birthday_celebration',
        { member: birthday_members.map(&:mention).first })
    end

    def multiple_members_message(birthday_members)
      t('events.birthday_celebration.multiple_members_birthday_celebration',
        { members: to_sentence(birthday_members.map(&:mention)) })
    end

    def to_sentence(members)
      case members.length
      when 2
        "#{members[0]} & #{members[1]}"
      else
        "#{members[0..-2].join(', ')} & #{members[-1]}"
      end
    end

    def birthday_role_set?
      !server_service.birthday_role.nil?
    end

    def celebration_channel
      server_service.server.channels.find { it.id == server_service.birthday_celebration_channel.id }
    end

    def birthdays_repository
      @birthdays_repository ||= Repositories::BirthdaysRepository.new(server_service:)
    end

    def logger
      @logger ||= Utility::Logger.instance
    end
  end
end
