# frozen_string_literal: true

module Status
  class StatusUpdater
    class << self
      STATUSES = [
        ['Playing Elden Ring', 0],
        ['Playing the destined death of the Golden Order', 0],
        ['Playing a tiny witch\'s grand scheme', 0],
        ['Watching the stars, quietly', 3],
        ['Watching a new night sky take shape', 3],
        ['Listening to whispers of the Two Fingers', 2],
        ['Playing Carian sorcery homework', 0],
        ['Playing hide and seek with Blaidd', 0],
        ['Watching a doll walk around for her', 3],
        ['Watching the moon from a great distance', 3],
        ['Listening to snow fall over Ranni\'s Rise', 2],
        ['Listening to the rustle of witch robes', 2],
        ['Watching a chill wind before the age of stars', 3],
        ['Competing in a very patient long game', 5],
        ['Playing a soul-searching side quest', 0],
        ['Playing finger maiden simulator', 0],
        ['Listening to the sound of severed fate', 2],
        ['Watching the age of stars begin', 3],
        ['Competing in a coup against the golden gods', 5],
        ['Watching a body she\'s not currently using', 3],
        ['Listening to cryptic prophecy podcasts', 2],
        ['Watching runes rearrange themselves', 3],
        ['Playing dodging the Tarnished\'s questions', 0],
        ['Playing a very long nap in a snowy tower', 0],
        ['Playing betrayal.exe', 0],
        ['Competing in the great rune negotiations', 5],
        ['Watching a puppet show, from the puppet\'s seat', 3],
        ['Playing sorcery homework due at midnight', 0],
        ['Watching Blaidd howl at nothing in particular', 3],
        ['Listening to Seluvis mutter something concerning', 2],
        ['Playing midwinter schemes', 0]
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
