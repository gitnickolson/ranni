# frozen_string_literal: true

module Utility
  module Messages
    module Embeds
      class EmbedBuilder
        MIN_PAGE_NUMBER = 1

        def initialize(astra:, pagination_key:, max_page_items: 20)
          @embed = Discordrb::Webhooks::Embed.new
          @fields = []
          @page = 1
          @max_page_items = max_page_items
          @pagination_key = pagination_key
          @astra = astra
        end

        attr_reader :pagination_key

        def call
          embed_setup
          fields_on_page.each do |field|
            embed.add_field(name: field.name, value: field.value, inline: field.inlined?)
          end

          embed
        end

        def update_fields(fields:)
          @fields = fields

          return self unless pagination?

          EmbedUpdateListener.new(embed_builder: self, pagination_key:, astra:).call

          self
        end

        def update_page(page:)
          @page = page

          self
        end

        def add_title(text:)
          @title = text

          self
        end

        def add_description(text:)
          @description = text

          self
        end

        def add_thumbnail(thumbnail: nil, thumbnail_url: nil)
          return self unless thumbnail || thumbnail_url

          if thumbnail
            @thumbnail = thumbnail
            return self
          end

          @thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: thumbnail_url)

          self
        end

        def add_image(image: nil, image_url: nil)
          return self unless image || image_url

          if image
            @image = image
            return self
          end

          @image = Discordrb::Webhooks::EmbedThumbnail.new(url: image_url)

          self
        end

        def change_color(color_code:)
          @color = color_code

          self
        end

        def change_footer(text:, icon_url: nil, append_to_default: false)
          @icon_url = icon_url

          if append_to_default
            @footer_appendage_text = " | #{text}"
            return self
          end

          @custom_footer_text = text

          self
        end

        def current_page
          page.clamp(MIN_PAGE_NUMBER, total_pages)
        end

        def pagination?
          total_pages > MIN_PAGE_NUMBER
        end

        def total_pages
          [(fields.length.to_f / max_page_items).ceil, MIN_PAGE_NUMBER].max
        end

        private

        attr_accessor :title, :description, :thumbnail, :image, :color, :custom_footer_text, :footer_appendage_text,
                      :page, :fields
        attr_reader :embed, :max_page_items, :astra, :icon_url

        def embed_setup
          embed.fields = []
          embed.title = title || ''
          embed.description = description || ''
          embed.thumbnail = thumbnail
          embed.image = image
          embed.color = color || ServerAccessor.server_color_code
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: footer_text, icon_url:)
        end

        def footer_text
          return custom_footer_text if custom_footer_text
          return default_footer_text + footer_appendage_text if footer_appendage_text

          default_footer_text
        end

        def default_footer_text
          "Seite #{current_page} von #{total_pages}"
        end

        def fields_on_page
          start_field_index = (current_page - 1) * max_page_items
          fields.slice(start_field_index, max_page_items) || []
        end
      end
    end
  end
end
