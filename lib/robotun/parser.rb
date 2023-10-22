# frozen_string_literal: true

module Robotun
  # Module for parsing commands.
  module Parser
    module_function

    def parse_line(line)
      command, args = line.to_s.strip.split(/\s+/, 2)
      args = args.split(",").map(&:strip) if args
      [command, args]
    end
  end
end
