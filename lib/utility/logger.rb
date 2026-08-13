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

    def error(message:)
      logging_tool.error(message)
    end

    private

    attr_reader :logging_tool

    def create_logging_tool
      $stdout.sync = true

      Ougai::Logger
        .new($stdout, progname: 'bot')
        .tap { |ougai_logger| ougai_logger.level = ::Logger::INFO }
    end
  end
end
