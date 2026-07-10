# frozen_string_literal: true

module Commands
  class Command
    NAME = :command
    DESCRIPTION = 'Command description'

    def initialize(astra:, server_id:, dependency_container:)
      @astra = astra
      @server_id = server_id
      @dependency_container = dependency_container
    end

    def command_permission_level
      namespace = self.class.name.split('::')[1]
      namespace.downcase.to_sym
    end

    def register
      astra.register_application_command(self.class::NAME, self.class::DESCRIPTION, server_id:)
    end

    def call
      astra.application_command(self.class::NAME) do |event|
        handle_event(event)
      end
    end

    private

    attr_reader :astra, :server_id, :event, :dependency_container

    def handle_event(event)
      @event = event

      unless user_permitted?
        return transmitter.error_response(event:, text: 'Du hast nicht die benötigten Berechtigungen.')
      end

      command_action
    end

    def command_action
      unimplemented_command_response
    end

    def unimplemented_command_response
      logger.warn(message: "No action implemented for #{self.class::NAME}")

      transmitter.error_response(
        event:,
        text: "No action implemented for #{self.class::NAME}"
      )
    end

    def user_permitted?
      user = event.user

      case command_permission_level
      when :administrator
        permission_checker.administrator?(user:)
      when :booster
        permission_checker.booster?(user:)
      else
        true
      end
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
      astra.servers[server_id]
    end

    def logger
      dependency_container.logger
    end

    def transmitter
      dependency_container.message_transmitter
    end

    def permission_checker
      dependency_container.permission_checker
    end
  end
end
