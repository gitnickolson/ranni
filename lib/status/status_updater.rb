# frozen_string_literal: true

module Status
  class StatusUpdater
    class << self
      STATUSES = [
        ['Elden Ring', 0],
        ['the destined death of the Golden Order', 0],
        ['a tiny witch\'s grand scheme', 0],
        ['the stars, quietly', 3],
        ['a new night sky take shape', 3],
        ['to whispers of the Two Fingers', 2],
        ['Carian sorcery homework', 0],
        ['hide and seek with Blaidd', 0],
        ['a doll walk around for her', 3],
        ['the moon from a great distance', 3],
        ['to snow fall over Ranni\'s Rise', 2],
        ['the rustle of witch robes', 2],
        ['a chill wind before the age of stars', 3],
        ['a very patient long game', 5],
        ['a soul-searching side quest', 0],
        ['finger maiden simulator', 0],
        ['to the sound of severed fate', 2],
        ['the age of stars begin', 3],
        ['a coup against the golden gods', 5],
        ['a body she\'s not currently using', 3],
        ['to cryptic prophecy podcasts', 2],
        ['runes rearrange themselves', 3],
        ['dodging the Tarnished\'s questions', 0],
        ['a very long nap in a snowy tower', 0],
        ['betrayal.exe', 0],
        ['the great rune negotiations', 5],
        ['a puppet show, from the puppet\'s seat', 3],
        ['sorcery homework due at midnight', 0],
        ['Blaidd howl at nothing in particular', 3],
        ['to Seluvis mutter something concerning', 2],
        ['midwinter schemes', 0]
      ].freeze
      ONE_HOUR = 3600
      ONE_MINUTE = 60

      def call(bot:)
        Thread.new do
          loop do
            if bot.connected?
              update_status(bot)
              sleep ONE_HOUR
            else
              sleep ONE_MINUTE
            end
          end
        end
      end

      private

      def update_status(bot)
        status = STATUSES.sample
        status_name = status[0]
        status_type = status[1]

        bot.update_status('online', "#{status_name} | Type \"/help\" for commands", nil, 0, false, status_type)
      end
    end
  end
end
