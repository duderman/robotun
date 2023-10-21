module Robotun
  module Commands
    UnknownCommandError = Class.new(Robotun::Error)

    module_function

    def for(command)
      case command
      when "PLACE"
        Place
      when "MOVE"
        Move
      when "LEFT"
        Left
      when "RIGHT"
        Right
      when "REPORT"
        Report
      else
        raise UnknownCommandError, "Unknown command: #{command}"
      end
    end

    class Base
      def self.run(*args)
        new(*args).run
      end

      attr_reader :field, :current_position, :args

      def initialize(field, current_position, args = [])
        @field = field
        @current_position = current_position
        @args = args
      end

      def run
        return current_position unless valid?

        new_position = calculate_new_position

        return new_position unless field.out_of_bounds?(new_position.x, new_position.y)

        Robotun.logger.warn("New position is out of bounds (#{new_position.to_s})")
        current_position
      end

      private

      def valid?
        raise NotImplementedError
      end

      def calculate_new_position
        raise NotImplementedError
      end
    end

    class Place < Base
      def valid?
        return true unless x.nil? || y.nil? || !Position::DIRECTIONS.include?(direction)

        Robotun.logger.warn("Invalid args for PLACE command: #{args}")
        false
      end

      def calculate_new_position
        Position.new(x, y, direction)
      end

      private

      def x
        args[0].to_i
      end

      def y
        args[1].to_i
      end

      def direction
        args[2].to_s.upcase
      end
    end

    class SimpleCommand < Base
      def valid?
        !current_position.nil?
      end
    end

    class Move < SimpleCommand
      def calculate_new_position
        case current_position.direction
        when "NORTH"
          Position.new(current_position.x, current_position.y + 1, current_position.direction)
        when "EAST"
          Position.new(current_position.x + 1, current_position.y, current_position.direction)
        when "SOUTH"
          Position.new(current_position.x, current_position.y - 1, current_position.direction)
        when "WEST"
          Position.new(current_position.x - 1, current_position.y, current_position.direction)
        end
      end
    end

    class Left < SimpleCommand
      def calculate_new_position
        case current_position.direction
        when "NORTH"
          Position.new(current_position.x, current_position.y, "WEST")
        when "EAST"
          Position.new(current_position.x, current_position.y, "NORTH")
        when "SOUTH"
          Position.new(current_position.x, current_position.y, "EAST")
        when "WEST"
          Position.new(current_position.x, current_position.y, "SOUTH")
        end
      end
    end

    class Right < SimpleCommand
      def calculate_new_position
        case current_position.direction
        when "NORTH"
          Position.new(current_position.x, current_position.y, "EAST")
        when "EAST"
          Position.new(current_position.x, current_position.y, "SOUTH")
        when "SOUTH"
          Position.new(current_position.x, current_position.y, "WEST")
        when "WEST"
          Position.new(current_position.x, current_position.y, "NORTH")
        end
      end
    end

    class Report < SimpleCommand
      def calculate_new_position
        Robotun.logger.info(current_position.to_s)

        current_position
      end
    end
  end
end
