# frozen_string_literal: true

module Commands
  module Public
    class Help < Commands::Command
      NAME = :help
      DESCRIPTION = 'Retrieve the help page with information on all commands'
      PERMISSION_ORDER = { public: 0, booster: 1, administrator: 2 }.freeze

      private

      def command_action
        embed_builder = create_embed_builder
        transmitter.embed_response(event:, embed_builder:, ephemeral: true)
      end

      def create_embed_builder
        embed_builder = builder.new(bot:, server_service:, pagination_key:)

        embed_builder.update_fields(fields:)
        embed_builder.add_title(text: t('commands.public.help.heading', { server_name: server.name }).to_s)
        embed_builder.add_thumbnail(thumbnail_url: event.user.avatar_url)
      end

      def fields
        visible_commands.flat_map.with_index do |command, index|
          index.zero? ? [command_field(command)] : [separator_field, command_field(command)]
        end
      end

      def visible_commands
        all_commands.reject { it < Subcommand }.select { should_add_field?(it) }
      end

      def command_field(command)
        field.new(name: header_line(command), value: command_description_string(command))
      end

      def header_line(command)
        line = "/#{command::NAME}"
        line += " #{permission_string(command)}" unless command < ParentCommand
        line
      end

      def command_field_name(command)
        name = "`/#{command::NAME}`"
        name += " #{permission_string(command)}" unless command < ParentCommand
        name
      end

      def separator_field
        field.new(name: '--------------------------------', value: '')
      end

      def command_description_string(command)
        return simple_description(command) unless command < ParentCommand

        visible_subcommands(command)
          .map { |subcommand| subcommand_description(command, subcommand) }
          .join("\n\n")
      end

      def visible_subcommands(command)
        command::SUBCOMMANDS.select { should_add_field?(it) }
      end

      def simple_description(command)
        "*#{translated_description(command)}*"
      end

      def subcommand_description(command, subcommand)
        "`/#{command::NAME} #{subcommand::NAME}` #{permission_string(subcommand)}\n" \
          "*#{translated_description(subcommand)}*"
      end

      def translated_description(command)
        t("commands.#{translation_path(command)}.description")
      end

      def should_add_field?(command)
        case command.permission_level
        when :booster
          event.user.boosting? || administrator?(event.user)
        when :administrator
          administrator?(event.user)
        else
          true
        end
      end

      def administrator?(user)
        permission_checker.administrator?(user:)
      end

      def translation_path(command)
        command.translation_path.join('.')
      end

      def permission_string(command)
        "| #{command.permission_level.capitalize}" if command.permission_level != :public
      end

      def all_commands
        @all_commands ||= [
          Commands::Administrator,
          Commands::Public
          # Commands::Booster
        ].flat_map { |mod| Utility::ClassCollector.all_classes_under(mod:) }
         .sort_by { [PERMISSION_ORDER.fetch(it.permission_level), it::NAME] }
      end
    end
  end
end
