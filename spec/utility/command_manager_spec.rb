# frozen_string_literal: true

RSpec.describe Utility::CommandManager do
  let(:fake_command_class) do
    Class.new(Commands::Command).tap do |klass|
      klass.const_set(:NAME, :fake_command)
      klass.const_set(:DESCRIPTION, 'Fake command')
    end
  end

  let(:other_fake_command_class) do
    Class.new(Commands::Command).tap do |klass|
      klass.const_set(:NAME, :other_fake_command)
      klass.const_set(:DESCRIPTION, 'Other fake command')
    end
  end

  let(:fake_subcommand_class) do
    Class.new(Commands::Subcommand).tap do |klass|
      klass.const_set(:NAME, :fake_subcommand)
      klass.const_set(:DESCRIPTION, 'Fake subcommand')
    end
  end

  let(:astra) { instance_double(Discordrb::Bot) }
  let(:server_id) { 123 }

  let(:logger) { instance_double(Utility::Logger) }
  let(:transmitter) { class_double(Utility::Messages::MessageTransmitter) }
  let(:permission_checker) { instance_double(Utility::PermissionChecker) }

  let(:command_manager) { described_class.new(astra:, server_id:) }

  before do
    allow(Utility::ClassCollector).to receive(:all_classes_under)
      .with(mod: Commands::Administrator)
      .and_return([fake_command_class, other_fake_command_class, fake_subcommand_class])

    allow(Commands::DependencyContainer).to receive(:new).and_return(
      instance_double(
        Commands::DependencyContainer,
        logger:,
        message_transmitter: transmitter,
        permission_checker:
      )
    )

    allow(Utility::Logger).to receive(:instance).and_return(logger)
    allow(logger).to receive(:log_info_and_print)

    allow(command_manager).to receive(:sleep)

    allow(astra).to receive(:register_application_command)
    allow(astra).to receive(:application_command)
    allow(astra).to receive(:delete_application_command)
  end

  describe '#register_commands' do
    context 'when no commands are registered yet' do
      before do
        allow(astra).to receive(:get_application_commands).with(server_id:).and_return([])
      end

      it 'registers every command with astra' do
        command_manager.register_commands

        expect(astra).to have_received(:register_application_command).with(:fake_command, 'Fake command', server_id:)
        expect(astra).to have_received(:register_application_command)
          .with(:other_fake_command, 'Other fake command', server_id:)
      end

      it 'returns a success message' do
        expect(command_manager.register_commands).to eq('Successfully registered all unregistered commands!')
      end
    end

    context 'when every command is already registered' do
      before do
        already_registered_commands = %i[fake_command other_fake_command].map do |name|
          instance_double(Discordrb::ApplicationCommand, name: name.to_s)
        end

        allow(astra).to receive(:get_application_commands).with(server_id:).and_return(already_registered_commands)
      end

      it 'does not register anything' do
        command_manager.register_commands

        expect(astra).not_to have_received(:register_application_command)
      end

      it 'returns nil' do
        expect(command_manager.register_commands).to be_nil
      end
    end
  end

  describe '#call_commands' do
    before do
      allow(astra).to receive(:get_application_commands).with(server_id:).and_return([])
    end

    it 'sets up an application command handler with astra for each command' do
      command_manager.call_commands

      expect(astra).to have_received(:application_command).with(:fake_command)
      expect(astra).to have_received(:application_command).with(:other_fake_command)
    end
  end

  describe '#all_commands' do
    it 'returns all commands sorted by NAME and excludes subcommands' do
      expect(command_manager.all_commands).to eq([fake_command_class, other_fake_command_class])
    end
  end

  describe '#unregister_commands' do
    let(:registered_fake_command) { instance_double(Discordrb::ApplicationCommand, id: 1, name: 'fake_command') }
    let(:registered_other_command) do
      instance_double(Discordrb::ApplicationCommand, id: 2, name: 'other_fake_command')
    end

    before do
      allow(astra).to receive(:get_application_commands)
        .with(server_id:)
        .and_return([registered_fake_command, registered_other_command])
    end

    context 'when called with no names filter' do
      it 'unregisters every registered command' do
        command_manager.unregister_commands

        expect(astra).to have_received(:delete_application_command).with(1, server_id:)
        expect(astra).to have_received(:delete_application_command).with(2, server_id:)
      end
    end

    context 'when called with a names filter' do
      it 'only unregisters commands matching the given names' do
        command_manager.unregister_commands(names: ['fake_command'])

        expect(astra).to have_received(:delete_application_command).with(1, server_id:)
        expect(astra).not_to have_received(:delete_application_command).with(2, server_id:)
      end
    end

    context 'when called with a names filter that matches nothing' do
      it 'does not unregister any commands' do
        command_manager.unregister_commands(names: ['nonexistent'])

        expect(astra).not_to have_received(:delete_application_command)
      end
    end
  end
end
