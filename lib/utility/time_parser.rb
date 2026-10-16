# frozen_string_literal: true

module Utility
  class TimeParser
    class << self
      def parse_to_readable_duration(duration:)
        seconds = duration.to_i % 60
        minutes = (duration.to_i / 60) % 60
        hours = (duration.to_i / (60 * 60)) % 24
        days = duration.to_i / (60 * 60 * 24)

        format_time(seconds, minutes, hours, days)
      end

      def parse_to_readable_date(date:)
        date_string = date.strftime('%A, %d.%m.%Y')
        translate_date(date_string)
      end

      def parse_to_readable_time(time:)
        "#{format_time_number(time.hour)}:#{format_time_number(time.min)}"
      end

      private

      def format_time(seconds, minutes, hours, days)
        parts = {
          'd' => days,
          'h' => hours,
          'm' => minutes,
          's' => seconds
        }.select { |_, value| value.positive? }
         .map { |unit, value| "#{value}#{unit}" }

        parts.empty? ? '0s' : parts.join(', ')
      end

      def format_time_number(number)
        number < 10 ? number.to_s.prepend('0') : number
      end

      def translate_date(date_string)
        day_name, rest_of_date = date_string.split(', ', 2)
        translated_day = days_hash[day_name]
        "#{translated_day}, #{rest_of_date}"
      end

      def days_hash
        {
          'Monday' => 'Mo',
          'Tuesday' => 'Di',
          'Wednesday' => 'Mi',
          'Thursday' => 'Do',
          'Friday' => 'Fr',
          'Saturday' => 'Sa',
          'Sunday' => 'So'
        }
      end
    end
  end
end
