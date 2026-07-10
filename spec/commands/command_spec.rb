# frozen_string_literal: true

require 'discordrb'

RSpec.describe Commands::Command do
  subject(:command) do
    described_class.new(
      astra:,
      server_id: 123,
      dependency_container:
    )
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

  describe '#register' do
    before do
      allow(astra).to receive(:register_application_command)
    end

    it 'registers the command with discord' do
      command.register

      expect(astra)
        .to have_received(:register_application_command)
        .with(
          :command,
          'Command description',
          server_id: 123
        )
    end
  end

  describe '#call' do
    let(:event) do
      instance_double(
        Discordrb::Events::ApplicationCommandEvent,
        user:
      )
    end

    let(:user) { instance_double(Discordrb::User) }

    before do
      allow(astra)
        .to receive(:application_command)
        .with(:command)
        .and_yield(event)

      allow(logger).to receive(:warn)
      allow(transmitter).to receive(:error_response)
    end

    context 'when the command has no permission requirement' do
      it 'executes the command action' do
        command.call

        expect(logger)
          .to have_received(:warn)
          .with(message: 'No action implemented for command')

        expect(transmitter)
          .to have_received(:error_response)
          .with(
            event:,
            text: 'No action implemented for command'
          )
      end
    end

    context 'when the command requires permissions' do
      context 'with administrator permission' do
        subject(:command) do
          administrator_command.new(
            astra:,
            server_id: 123,
            dependency_container:
          )
        end

        let(:administrator_command) do
          stub_const(
            'Commands::Administrator::TestCommand',
            Class.new(described_class)
          )
        end

        it 'checks administrator permission' do
          allow(permission_checker)
            .to receive(:administrator?)
            .with(user:)
            .and_return(true)

          command.call

          expect(permission_checker)
            .to have_received(:administrator?)
            .with(user:)
        end
      end

      context 'with booster permission' do
        subject(:command) do
          booster_command.new(
            astra:,
            server_id: 123,
            dependency_container:
          )
        end

        let(:booster_command) do
          stub_const(
            'Commands::Booster::TestCommand',
            Class.new(described_class)
          )
        end

        it 'checks booster permission' do
          allow(permission_checker)
            .to receive(:booster?)
            .with(user:)
            .and_return(true)

          command.call

          expect(permission_checker)
            .to have_received(:booster?)
            .with(user:)
        end
      end

      context 'when the user is not permitted' do
        subject(:command) do
          administrator_command.new(
            astra:,
            server_id: 123,
            dependency_container:
          )
        end

        let(:administrator_command) do
          stub_const(
            'Commands::Administrator::TestCommand',
            Class.new(described_class)
          )
        end

        it 'returns a permission error' do
          allow(permission_checker)
            .to receive(:administrator?)
            .with(user:)
            .and_return(false)

          command.call

          expect(transmitter)
            .to have_received(:error_response)
            .with(
              event:,
              text: 'Du hast nicht die benötigten Berechtigungen.'
            )
        end
      end
    end
  end
end
