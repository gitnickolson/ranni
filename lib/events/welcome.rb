# frozen_string_literal: true

module Events
  class Welcome
    WELCOME_MESSAGE_GIF = 'https://static2.klipy.com/ii/c3a19a0b747a76e98651f2b9a3cca5ff/ce/d4/FGiYVznU.gif'

    include Translations::Translatable

    def self.listen(bot:)
      bot.member_join do |event|
        server_service = Utility::ServerService.new(bot:, server_id: event.server.id)

        welcome_event = new(bot:, server_service:)
        welcome_event.call(event)
      end
    end

    def initialize(bot:, server_service:)
      @bot = bot
      @server_service = server_service
    end

    def call(event)
      sync_level_roles(event)
      send_welcome_message(event)
    end

    private

    attr_reader :bot, :server_service

    def sync_level_roles(event)
      level = levels_repository.find_by_user_id(user_id: event.user.id)

      rank_synchronizer.call(level:)
    end

    def send_welcome_message(event)
      channel = server_service.welcome_message_channel
      return unless channel

      embed_builder = create_embed_builder(event)
      Utility::Messages::MessageTransmitter.send_embed_message(channel:, embed_builder:)
    end

    def create_embed_builder(event)
      embed_builder = Utility::Messages::Embeds::EmbedBuilder.new(bot:, server_service:,
                                                                  pagination_key: pagination_key(event))
      embed_builder.add_title(text: t('events.welcome.embed_title', { server_name: server_service.server.name }))
      embed_builder.add_description(text: t('events.welcome.embed_description',
                                            { user_mention: event.user.mention, username: event.user.username }))
      embed_builder.add_image(url: WELCOME_MESSAGE_GIF)
      embed_builder.change_footer(text: '')
    end

    def pagination_key(event)
      "welcome-#{event.user.id}-#{Time.now.to_i}"
    end

    def rank_synchronizer
      @rank_synchronizer ||= Utility::RankSynchronizer.new(server_service:)
    end

    def levels_repository
      @levels_repository ||= Repositories::LevelsRepository.new(server_service:)
    end
  end
end
