# frozen_string_literal: true

module Events
  class RankDelete
    def self.listen(bot:)
      bot.server_role_delete do |event|
        server_service = Utility::ServerService.new(bot:, server_id: event.server.id)

        welcome_event = new(server_service:, event:)
        welcome_event.call
      end
    end

    def initialize(server_service:, event:)
      @server_service = server_service
      @event = event
    end

    def call
      rank = ranks_repository.find_by_role(role_id: event.id)
      return if rank.nil?

      ranks_repository.delete(role_id: rank.role_id)
    end

    private

    attr_reader :server_service, :event

    def ranks_repository
      @ranks_repository ||= Repositories::RanksRepository.new(server_service:)
    end
  end
end
