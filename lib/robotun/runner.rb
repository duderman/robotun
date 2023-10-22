# frozen_string_literal: true

module Robotun
  # Runs commands one by one.
  class Runner
    def initialize(input = nil)
      @field = Field.new
      @current_position = nil
      @input = input || Input.new
    end

    def run
      @input.each_line { run_command(_1) }
    end

    private

    def run_command(line)
      command, args = Parser.parse_line(line)

      @current_position = Commands.run(command, @field, @current_position, args)
    rescue Commands::UnknownCommandError => e
      Robotun.logger.error(e.message)
    end
  end
end
