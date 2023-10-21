# frozen_string_literal: true

module Robotun
  class Field
    DEFAULT_WIDTH = 5
    DEFAULT_HEIGHT = 5

    attr_reader :width, :height

    def initialize(width = nil, height = nil)
      @width = width || DEFAULT_WIDTH
      @height = height || DEFAULT_HEIGHT
    end

    def out_of_bounds?(x, y)
      x.negative? || y.negative? || x >= width || y >= height
    end
  end
end
