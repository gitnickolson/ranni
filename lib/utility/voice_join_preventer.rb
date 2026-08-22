# frozen_string_literal: true

module Utility
  class VoiceJoinPreventer
    def initialize(bot:)
      @bot = bot
    end

    def call
      bot.voice_state_update do |event|
        next unless event.old_channel.nil?

        handle_event(event)
      end
    end

    private

    attr_reader :bot

    def handle_event(event)
      server_service = Utility::ServerService.new(bot:, server_id: event.server.id)
      levels_repository = Repositories::LevelsRepository.new(server_service:)

      user_level = levels_repository.find_by_user_id(user_id: event.user.id).numeric
      voice_requirement = server_service.voice_chat_level_requirement

      return if user_level >= voice_requirement

      kick_user(event, server_service)
      message_user(event, voice_requirement, server_service)
    end

    def kick_user(event, server_service)
      server_service.server.move(event.user, nil)
    end

    def message_user(event, voice_requirement, server_service)
      text = minimum_requirement_pm(voice_requirement, server_service)
      Messages::MessageTransmitter.send_message(channel: event.user.pm, text:)
    rescue StandardError
      text = minimum_requirement_message(event.user, voice_requirement, server_service)
      Messages::MessageTransmitter.send_message(channel: event.channel, text:)
    end

    def minimum_requirement_pm(voice_requirement, server_service)
      t('utility.voice_join_preventer.pm', server_service, { voice_requirement: })
    end

    def minimum_requirement_message(user, voice_requirement, server_service)
      t('utility.voice_join_preventer.channel_message', server_service,
        { user_mention: user.mention, voice_requirement: })
    end

    def t(key, server_service, parameters = {})
      key_translator(server_service).translate(key, parameters)
    end

    def key_translator(server_service)
      @key_translator ||= Translations::KeyTranslator.new(server_service:)
    end
  end
end
