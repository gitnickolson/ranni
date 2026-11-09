# frozen_string_literal: true

require 'date'

module Utility
  class TimeParser
    DEFAULT_LOCALE = 'en'
    DATE_FORMATS = {
      'en' => '%A, %B %d, %Y',
      'de' => '%A, %d.%m.%Y'
    }.freeze
    WEEKDAY_ABBREVIATIONS = {
      'de' => %w[So Mo Di Mi Do Fr Sa]
    }.freeze

    class << self
      def parse_to_readable_duration(duration:)
        seconds = duration.to_i % 60
        minutes = (duration.to_i / 60) % 60
        hours = (duration.to_i / (60 * 60)) % 24
        days = duration.to_i / (60 * 60 * 24)

        format_time(seconds, minutes, hours, days)
      end

      def parse_to_readable_date(date:, locale: DEFAULT_LOCALE)
        locale = supported_locale(locale)
        formatted_date = date.strftime(DATE_FORMATS.fetch(locale))

        localize_weekday(formatted_date, date, locale)
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

      def supported_locale(locale)
        locale = locale.to_s.downcase

        DATE_FORMATS.key?(locale) ? locale : DEFAULT_LOCALE
      end

      def localize_weekday(formatted_date, date, locale)
        abbreviation = WEEKDAY_ABBREVIATIONS.dig(locale, date.wday)

        return formatted_date if abbreviation.nil?

        _, rest_of_date = formatted_date.split(', ', 2)

        "#{abbreviation}, #{rest_of_date}"
      end
    end
  end
end
