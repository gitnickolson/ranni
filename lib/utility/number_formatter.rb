# frozen_string_literal: true

module Utility
  class NumberFormatter
    UNITS = [
      [10**6,   ' M'],
      [10**9,   ' B'],
      [10**12,  ' T'],
      [10**15,  ' Qa'],
      [10**18,  ' Qi'],
      [10**21,  ' Sx'],
      [10**24,  ' Sp'],
      [10**27,  ' Oc'],
      [10**30,  ' No'],
      [10**33,  ' Dc'],
      [10**36,  ' Ud'],
      [10**39,  ' Dd'],
      [10**42,  ' Td'],
      [10**45,  ' Qad'],
      [10**48,  ' Qid'],
      [10**51,  ' Sxd'],
      [10**54,  ' Spd'],
      [10**57,  ' Ocd'],
      [10**60,  ' Nod'],
      [10**63,  ' Vg'],
      [10**66,  ' Uv'],
      [10**69,  ' Dv'],
      [10**72,  ' Tv'],
      [10**75,  ' Qav'],
      [10**78,  ' Qiv'],
      [10**81,  ' Sxv'],
      [10**84,  ' Spv'],
      [10**87,  ' Ocv'],
      [10**90,  ' Nov'],
      [10**93,  ' Tg'],
      [10**96,  ' Qg'],
      [10**99,  ' QiG'],
      [10**102, ' X'],
      [10**105, ' UX'],
      [10**108, ' DX'],
      [10**111, ' TX'],
      [10**114, ' QAX'],
      [10**117, ' QIX']
    ].freeze

    MAX_VALUE = 10**117
    GROUP_SEPARATOR = '.'

    class << self
      def humanize(number:, precision: 2, shorten: true)
        return '♾️' if number >= MAX_VALUE
        return format_full(number) if !shorten || number < UNITS.first[0]

        format_short(number, precision)
      end

      private

      def format_full(number)
        number
          .to_i
          .to_s
          .reverse
          .scan(/\d{1,3}/)
          .join(GROUP_SEPARATOR)
          .reverse
      end

      def format_short(number, precision)
        value, label = unit_for(number)
        raw = number.to_f / value

        truncated = truncate(raw, precision)
        formatted = strip_trailing_zeros(truncated)

        "#{formatted}#{label}"
      end

      def unit_for(number)
        UNITS.rfind { |value, _| number >= value }
      end

      def truncate(value, precision)
        factor = 10**precision
        (value * factor).floor / factor.to_f
      end

      def strip_trailing_zeros(number)
        number
          .to_s
          .sub(/\.0+\z/, '')
          .sub(/(\.\d*[1-9])0+\z/, '\1')
      end
    end
  end
end
