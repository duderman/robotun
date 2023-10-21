# frozen_string_literal: true

# rubocop:disable Style/Documentation
module Robotun
  module Commands
    UnknownCommandError = Class.new(Robotun::Error)

    module_function

    def run(command, field, current_position, args = [])
      command_class_for(command.to_s.upcase).run(field, current_position, args)
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

        Robotun.logger.warn("New position is out of bounds (#{new_position})")
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
      def calculate_new_position # rubocop:disable Metrics/AbcSize
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

    class Rotation < SimpleCommand
      def calculate_new_position
        Position.new(current_position.x, current_position.y, new_direction)
      end

      private

      def new_direction
        Position::DIRECTIONS[(Position::DIRECTIONS.index(current_position.direction) + turn) % 4]
      end

      def turn
        raise NotImplementedError
      end
    end

    class Left < Rotation
      private

      def turn
        -1
      end
    end

    class Right < Rotation
      private

      def turn
        1
      end
    end

    class Report < SimpleCommand
      def calculate_new_position
        Robotun.logger.info(current_position.to_s)

        current_position
      end
    end

    COMMANDS_CLASSES = {
      "PLACE" => Place,
      "MOVE" => Move,
      "LEFT" => Left,
      "RIGHT" => Right,
      "REPORT" => Report
    }.freeze

    def command_class_for(command)
      COMMANDS_CLASSES.fetch(command) do
        raise UnknownCommandError, "Unknown command: #{command}"
      end
    end
  end
end
# rubocop:enable Style/Documentation
