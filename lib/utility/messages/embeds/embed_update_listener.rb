# frozen_string_literal: true

module Utility
  module Messages
    module Embeds
      class EmbedUpdateListener
        TEN_MINUTES = 600

        def initialize(embed_builder:, pagination_key:, astra:)
          @embed_builder = embed_builder
          @pagination_key = pagination_key
          @astra = astra
        end

        def call
          previous_page_button_handler = previous_page_button
          next_page_button_handler = next_page_button

          Thread.new do
            sleep TEN_MINUTES

            [previous_page_button_handler, next_page_button_handler].each { astra.remove_handler(it) }
          end
        end

        private

        attr_reader :embed_builder, :pagination_key, :astra

        def previous_page_button
          astra.button(custom_id: "#{pagination_key}-previous") do |event|
            page = embed_builder.current_page == 1 ? embed_builder.total_pages : embed_builder.current_page - 1

            embed_builder.update_page(page:)
            Utility::Messages::MessageTransmitter.update_embed_message(event:, embed_builder:)
          end
        end

        def next_page_button
          astra.button(custom_id: "#{pagination_key}-next") do |event|
            page = embed_builder.current_page == embed_builder.total_pages ? 1 : embed_builder.current_page + 1

            embed_builder.update_page(page:)
            Utility::Messages::MessageTransmitter.update_embed_message(event:, embed_builder:)
          end
        end
      end
    end
  end
end
