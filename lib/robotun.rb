# frozen_string_literal: true

require 'logger'
require 'zeitwerk'
Zeitwerk::Loader.for_gem.setup

module Robotun
  class Error < StandardError; end

  module_function

  def run
    Input.new.each_line { puts _1 }
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def logger=(logger)
    @logger = logger
  end
end
