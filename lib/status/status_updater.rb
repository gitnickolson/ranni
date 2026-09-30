# frozen_string_literal: true

module Status
  class StatusUpdater
    class << self
      STATUSES = [
        ['Guarding Falkreath Hold', 0],
        ['Watching the cemetery gates', 3],
        ['Listening to the pines whisper', 2],
        ['Playing cards at the guard barracks', 0],
        ['Watching for dragons over the treeline', 3],
        ['Listening for trouble on the road to Helgen', 2],
        ['Guarding the Jarl’s longhouse', 0],
        ['Watching travelers pass through Falkreath', 3],
        ['Listening to stories at Dead Man’s Drink', 2],
        ['Playing fetch with Barbas', 0],
        ['Watching the graveyard shift get literal', 3],
        ['Listening to wolves beyond the walls', 2],
        ['Guarding against bandits from the woods', 0],
        ['Watching the road to Whiterun', 3],
        ['Listening to Lod work the forge', 2],
        ['Playing “not another dragon attack”', 0],
        ['Watching over the Hall of the Dead', 3],
        ['Listening to rain on the guardhouse roof', 2],
        ['Guarding Falkreath from absolutely everything', 0],
        ['Watching suspicious adventurers loot barrels', 3],
        ['Listening for arrows near knees', 2],
        ['Playing lookout by the southern gate', 0],
        ['Watching the Dark Brotherhood rumors spread', 3],
        ['Listening to the forest get too quiet', 2],
        ['Guarding the road to Lakeview Manor', 0],
        ['Watching hunters return from the hold', 3],
        ['Listening to dragons definitely not nearby', 2],
        ['Playing patrol duty in the pines', 0],
        ['Watching the Jarl’s taxes go unpaid', 3],
        ['Competing in the annual knee injury avoidance contest', 5]
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
