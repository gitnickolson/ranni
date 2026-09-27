# frozen_string_literal: true

module Utility
  module Messages
    class MessageTransmitter
      MESSAGE_DELETION_TIME = 3

      class << self
        def send_message(channel:, text:, buttons: [])
          return channel.send_message(text) if buttons.empty?

          view = Discordrb::Webhooks::View.new
          build_action_row(view, buttons)

          channel.send_message(text, false, nil, nil, nil, nil, view)
        end

        def send_embed_message(channel:, embed_builder:, attachment: nil)
          embed = embed_builder.call

          if embed_builder&.pagination?
            return channel.send_embed('', embed, [attachment].compact) do |_, view|
              build_action_row(view, pagination_buttons(embed_builder))
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
              build_action_row(view, pagination_buttons(embed_builder))
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
            return event.update_message(embeds: [embed], attachments: [attachment].compact,
                                        ephemeral:) do |_, view|
              build_action_row(view, pagination_buttons(embed_builder))
            end
          end

          event.update_message(embeds: [embed], attachments: [attachment].compact, ephemeral:)
        end

        private

        def build_action_row(view, buttons)
          view.row do |row|
            buttons.each do |button|
              row.button(custom_id: button.custom_id, label: button.label,
                         style: button.style, disabled: button.disabled?)

              next if button.handler.nil?

              Buttons::ButtonRegistry.instance.register(custom_id: button.custom_id, &button.handler)
            end
          end
        end

        def pagination_buttons(embed_builder)
          [create_previous_page_button(embed_builder), create_next_page_button(embed_builder)]
        end

        def create_previous_page_button(embed_builder)
          Buttons::Button.new(custom_id: "#{embed_builder.pagination_key}-previous", label: '⬅️',
                              style: 2) do |event|
            page = embed_builder.current_page == 1 ? embed_builder.total_pages : embed_builder.current_page - 1
            embed_builder.update_page(page:)
            MessageTransmitter.update_embed_message(event:, embed_builder:)
          end
        end

        def create_next_page_button(embed_builder)
          Buttons::Button.new(custom_id: "#{embed_builder.pagination_key}-next", label: '➡️',
                              style: 2) do |event|
            page = embed_builder.current_page == embed_builder.total_pages ? 1 : embed_builder.current_page + 1
            embed_builder.update_page(page:)
            MessageTransmitter.update_embed_message(event:, embed_builder:)
          end
        end
      end
    end
  end
end
