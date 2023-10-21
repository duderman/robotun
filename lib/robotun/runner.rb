module Robotun
  class Runner
    def initialize(input = nil)
      @field = Field.new
      @current_position = nil
      @input = input || Input.new
    end

    def run
      @input.each_line(&method(:process_line))
    end

    private

    def process_line(line)
      command, args = line.strip.split(/\s+/)
      args = args.split(",") if args

      @current_position = Commands.run(command, @field, @current_position, args)
    rescue Commands::UnknownCommandError => e
      Robotun.logger.error(e.message)
    end
  end
end