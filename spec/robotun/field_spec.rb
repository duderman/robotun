# frozen_string_literal: true

RSpec.describe Robotun::Field do
  describe "#initialize" do
    it "sets width and height" do
      field = described_class.new(1, 2)
      expect(field.width).to eq 1
      expect(field.height).to eq 2
    end

    context "when width or height is not given" do
      it "uses default width and height" do
        field = described_class.new
        expect(field.width).to eq 5
        expect(field.height).to eq 5

        field = described_class.new(nil, nil)
        expect(field.width).to eq 5
        expect(field.height).to eq 5
      end
    end
  end

  describe "#out_of_bounds?" do
    it "checks if x and y are within field" do
      field = described_class.new(2, 2)
      expect(field).to be_out_of_bounds(-1, -1)
      expect(field).not_to be_out_of_bounds(0, 0)
      expect(field).not_to be_out_of_bounds(1, 1)
      expect(field).to be_out_of_bounds(2, 2)
      expect(field).to be_out_of_bounds(3, 3)
    end
  end
end
