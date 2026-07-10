# frozen_string_literal: true

module Utility
  module Messages
    class MessageTransmitter
      MESSAGE_DELETION_TIME = 3

      class << self
        def send_message(channel:, text:)
          channel.send_message(text)
        end

        def send_embed_message(channel:, embed_builder:, attachment: nil)
          embed = embed_builder.call

          if embed_builder&.pagination?
            return channel.send_embed('', embed, [attachment].compact) do |_, view|
              build_action_row(view, embed_builder)
            end
          end

          channel.send_embed('', embed, [attachment].compact)
        end

        def send_file(channel:, file:, spoiler: true)
          channel.send_file(file, spoiler:)
        end

        def response(event:, text:, attachment: nil, ephemeral: false, delete: false)
          event.respond(content: text, attachments: [attachment].compact, ephemeral:)

          return unless delete

          delete_response(event:)
        end

        def embed_response(event:, embed_builder:, attachment: nil, ephemeral: false, delete: false)
          embed = embed_builder.call

          if embed_builder&.pagination?
            return event.respond(embeds: [embed], attachments: [attachment].compact, ephemeral:) do |_, view|
              build_action_row(view, embed_builder)
            end
          end

          event.respond(embeds: [embed], attachments: [attachment].compact, ephemeral:)

          return unless delete

          delete_response(event:)
        end

        def error_response(event:, text:, ephemeral: true, delete: true)
          response(event:, text:, ephemeral:)

          return unless delete

          delete_response(event:)
        end

        def delete_response(event:)
          sleep MESSAGE_DELETION_TIME
          event.delete_response
        end

        def update_embed_message(event:, embed_builder:, attachment: nil, ephemeral: false)
          embed = embed_builder.call

          if embed_builder.pagination?
            return event.update_message(embeds: [embed], attachments: [attachment].compact, ephemeral:) do |_, view|
              build_action_row(view, embed_builder)
            end
          end

          event.update_message(embeds: [embed], attachments: [attachment].compact, ephemeral:)
        end

        private

        def build_action_row(view, embed_builder)
          view.row do |row|
            row.button(custom_id: "#{embed_builder.pagination_key}-previous", label: '⬅️', style: 2,
                       disabled: false)
            row.button(custom_id: "#{embed_builder.pagination_key}-next", label: '➡️', style: 2,
                       disabled: false)
          end
        end
      end
    end
  end
end
