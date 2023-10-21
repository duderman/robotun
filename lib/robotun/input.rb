module Robotun
  class Input
    def each_line(&block)
      return if !block_given? || no_data?

      ARGF.each_line do |line|
        yield line.chomp
      end
    end

    def no_data?
      $stdin.stat.size.zero? && ARGF.filename == '-'
    rescue Errno::ENOENT
      Robotun.logger.error "File not found!"
      true
    end
  end
end
