# frozen_string_literal: true

require 'discordrb'

RSpec.describe Commands::Subcommand do
  subject(:subcommand) do
    Commands::TestAdministratorSubcommand.new(
      parent_command:,
      astra:,
      server_id: 123,
      dependency_container:
    )
  end

  let(:parent_command_class) do
    Class.new(Commands::ParentCommand).tap do |klass|
      klass.const_set(:NAME, :test_parent)
      klass.const_set(:DESCRIPTION, 'Test parent')
    end
  end

  let(:administrator_subcommand_class) do
    Class.new(described_class).tap do |klass|
      klass.const_set(:NAME, :test_administrator_subcommand)
      klass.const_set(:DESCRIPTION, 'Test administrator subcommand')
    end
  end

  let(:booster_subcommand_class) do
    Class.new(described_class).tap do |klass|
      klass.const_set(:NAME, :test_booster_subcommand)
      klass.const_set(:DESCRIPTION, 'Test booster subcommand')
    end
  end

  let(:astra) { instance_double(Discordrb::Bot) }

  let(:logger) { instance_double(Utility::Logger) }
  let(:transmitter) { class_double(Utility::Messages::MessageTransmitter) }
  let(:permission_checker) { instance_double(Utility::PermissionChecker) }

  let(:dependency_container) do
    instance_double(
      Commands::DependencyContainer,
      logger:,
      message_transmitter: transmitter,
      permission_checker:
    )
  end

  let(:parent_command) do
    Commands::TestParentCommand.new(
      astra:,
      server_id: 123,
      dependency_container:
    )
  end

  before do
    stub_const('Commands::TestParentCommand', parent_command_class)
    stub_const('Commands::TestAdministratorSubcommand', administrator_subcommand_class)
  end

  describe '#register' do
    let(:discord_parent_command) { instance_double(Discordrb::Interactions::OptionBuilder) }

    before do
      allow(discord_parent_command)
        .to receive(:subcommand)
    end

    it 'registers the subcommand on the parent command' do
      subcommand.register(discordrb_parent_command: discord_parent_command)

      expect(discord_parent_command)
        .to have_received(:subcommand)
        .with(:test_administrator_subcommand, 'Test administrator subcommand')
    end
  end
end
