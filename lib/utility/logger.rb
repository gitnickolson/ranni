# frozen_string_literal: true

require 'ougai'
require 'singleton'

module Utility
  class Logger
    include Singleton

    def initialize
      @logging_tool = create_logging_tool
    end

    def warn(message:)
      logging_tool.warn(message)
    end

    def info(message:)
      logging_tool.info(message)
    end

    def log_info_and_print(message:)
      logging_tool.info(message)
      pp message
    end

    private

    attr_reader :logging_tool

    def create_logging_tool
      Ougai::Logger
        .new($stdout, progname: 'astra')
        .tap { |ougai_logger| ougai_logger.level = ::Logger::WARN }
    end
  end
end
