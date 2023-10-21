module Robotun
  # Represents the position of the robot.
  class Position
    InvalidDirectionError = Class.new(StandardError)

    DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze

    attr_reader :x, :y, :direction

    def initialize(x, y, direction)
      raise InvalidDirectionError unless DIRECTIONS.include?(direction)
      @x = x
      @y = y
      @direction = direction
    end

    def to_s
      "#{x},#{y},#{direction}"
    end

    def ==(other)
      x == other.x && y == other.y && direction == other.direction
    end
  end
end
