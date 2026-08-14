# frozen_string_literal: true

module Utility
  class TimeParser
    class << self
      def parse_to_readable_time(time:)
        seconds = time.to_i % 60
        minutes = (time.to_i / 60) % 60
        hours = (time.to_i / (60 * 60)) % 24
        days = time.to_i / (60 * 60 * 24)

        format_time(seconds, minutes, hours, days)
      end

      def parse_to_readable_date(date:)
        date_string = date.strftime('%A, %d.%m.%Y')
        translate_date(date_string)
      end

      def hour_string_from_time(time:)
        "#{format_time_number(time.hour)}:#{format_time_number(time.min)}"
      rescue StandardError
        nil
      end

      private

      def format_time(seconds, minutes, hours, days)
        formatted_time_string = ''
        formatted_time_string += format_days(days) if days.positive?
        formatted_time_string += format_hours(hours, days) if hours.positive?
        formatted_time_string += format_minutes(minutes, hours) if minutes.positive?
        formatted_time_string += format_seconds(seconds, minutes) if seconds.positive? || formatted_time_string.empty?

        formatted_time_string
      end

      def format_days(days)
        days == 1 ? 'Einen Tag, ' : "#{days} Tage, "
      end

      def format_hours(hours, days)
        hours == 1 ? one_hour_string_format(days) : "#{hours} Stunden, "
      end

      def one_hour_string_format(days)
        days.positive? ? 'eine Stunde, ' : 'Eine Stunde, '
      end

      def format_minutes(minutes, hours)
        minutes == 1 ? one_minute_string_format(hours) : "#{minutes} Minuten, "
      end

      def one_minute_string_format(hours)
        hours.positive? ? 'eine Minute, ' : 'Eine Minute, '
      end

      def format_seconds(seconds, minutes)
        seconds == 1 ? one_second_string_format(minutes) : "#{seconds} Sekunden"
      end

      def one_second_string_format(minutes)
        minutes.positive? ? 'eine Sekunde' : 'Eine Sekunde'
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
