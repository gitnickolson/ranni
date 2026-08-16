# frozen_string_literal: true

module Events
  class Welcome
    WELCOME_MESSAGE_GIF = 'https://static2.klipy.com/ii/c3a19a0b747a76e98651f2b9a3cca5ff/ce/d4/FGiYVznU.gif'

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
      channel_id = preferences_repository.welcome_message_channel_id
      return unless channel_id

      channel = server_service.channel_from_id(channel_id:)

      embed_builder = create_embed_builder(event)
      Utility::Messages::MessageTransmitter.send_embed_message(channel:, embed_builder:)
    end

    private

    attr_reader :bot, :server_service

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

    def t(key, parameters = {})
      key_translator.translate(key, parameters)
    end

    def key_translator
      @key_translator ||= Translations::KeyTranslator.new(server_service:)
    end

    def preferences_repository
      @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server_service.server.id)
    end
  end
end
