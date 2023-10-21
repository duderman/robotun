# frozen_string_literal: true

module Robotun
  # Reads input from ARGF.
  class Input
    def each_line
      return if !block_given? || no_data?

      ARGF.each_line do |line|
        yield line.chomp
      end
    end

    def no_data?
      $stdin.stat.size.zero? && ARGF.filename == "-" # rubocop:disable Style/ZeroLengthPredicate
    rescue Errno::ENOENT
      Robotun.logger.error "File not found!"
      true
    end
  end
end
