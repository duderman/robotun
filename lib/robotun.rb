# frozen_string_literal: true

require "logger"
require "zeitwerk"
Zeitwerk::Loader.for_gem.setup

# Main module for the gem.
module Robotun
  class Error < StandardError; end

  module_function

  def run
    Runner.new.run
  end

  def logger
    @logger ||= Logger.new($stdout)
  end

  def logger=(logger)
    @logger = logger
  end
end
