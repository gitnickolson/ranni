# frozen_string_literal: true

require 'discordrb'

RSpec.describe Commands::ParentCommand do
  subject(:parent_command) do
    Commands::TestParentCommand.new(
      astra:,
      server_id: 123,
      dependency_container:
    )
  end

  let(:subcommand_instance) do
    instance_double(subcommand_class)
  end

  let(:subcommand_class) do
    Class.new(Commands::Subcommand).tap do |klass|
      klass.const_set(:NAME, :test_subcommand)
      klass.const_set(:DESCRIPTION, 'Test subcommand')
    end
  end

  let(:parent_command_class) do
    Class.new(described_class).tap do |klass|
      klass.const_set(:NAME, :test_parent)
      klass.const_set(:DESCRIPTION, 'Test parent')
      klass.const_set(:SUBCOMMANDS, [subcommand_class])
    end
  end

  let(:astra) { instance_double(Discordrb::Bot) }

  let(:dependency_container) do
    instance_double(
      Commands::DependencyContainer
    )
  end

  before do
    stub_const('Commands::TestParentCommand', parent_command_class)

    allow(subcommand_class)
      .to receive(:new)
      .and_return(subcommand_instance)
  end

  describe '#register' do
    let(:discord_parent_command) do
      instance_double(Discordrb::Interactions::OptionBuilder)
    end

    before do
      allow(astra)
        .to receive(:register_application_command)
        .and_yield(discord_parent_command)

      allow(subcommand_instance)
        .to receive(:register)
    end

    it 'registers its subcommands' do
      parent_command.register

      expect(subcommand_instance)
        .to have_received(:register)
        .with(
          discordrb_parent_command: discord_parent_command
        )
    end
  end

  describe '#call' do
    before do
      allow(subcommand_instance)
        .to receive(:call)
    end

    it 'calls its subcommands' do
      parent_command.call

      expect(subcommand_instance)
        .to have_received(:call)
    end
  end
end
