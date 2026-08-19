# frozen_string_literal: true

module Commands
  class Command
    NAME = :command
    DESCRIPTION = 'Command description'
    PARAMETERS = [].freeze

    extend Registerable
    include Translations::Translatable

    def self.permission_level
      namespace = name.split('::')[1]
      namespace.downcase.to_sym
    end

    def initialize(bot:)
      @bot = bot
    end

    def handle_event(event)
      @event = event
      @server_service = Utility::ServerService.new(bot:, server_id: event.server.id)

      return transmitter.error_response(event:, text: t('commands.command.not_permitted')) unless user_permitted?

      command_action
    rescue StandardError => e
      logger.error(message: "An error occured: #{e}")
      transmitter.error_response(event:, text: 'Ein Fehler ist aufgetreten. Bitte versuche es erneut oder schreibe ' \
                                               'eine Nachricht an `nicknickolson`.')
    end

    private

    attr_reader :bot, :event, :server_service

    def command_action
      unimplemented_command_response
    end

    def unimplemented_command_response
      logger.warn(message: "No action implemented for #{self.class::NAME}")

      transmitter.error_response(
        event:,
        text: t('commands.command.no_functionality_implemented', { command_name: self.class::NAME })
      )
    end

    def user_permitted?
      user = event.user

      case permission_level
      when :administrator
        permission_checker.administrator?(user:)
      when :booster
        permission_checker.booster?(user:)
      else
        true
      end
    end

    def permission_level
      namespace = self.class.name.split('::')[1]
      namespace.downcase.to_sym
    end

    def builder
      Utility::Messages::Embeds::EmbedBuilder
    end

    def field
      Utility::Messages::Embeds::EmbedField
    end

    def pagination_key
      "#{self.class::NAME}-#{event.user.id}-#{Time.now.to_i}"
    end

    def server
      server_service.server
    end

    def permission_checker
      @permission_checker ||= Utility::PermissionChecker.new(bot:, server_service:)
    end

    def logger
      @logger ||= Utility::Logger.instance
    end

    def transmitter
      Utility::Messages::MessageTransmitter
    end
  end
end
