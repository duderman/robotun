RSpec.describe Robotun::Position do
  describe "#initialize" do
    it "sets x, y and direction" do
      position = described_class.new(1, 2, "NORTH")
      expect(position.x).to eq 1
      expect(position.y).to eq 2
      expect(position.direction).to eq "NORTH"
    end

    context 'with unknown direction' do
      it 'raises error' do
        expect { described_class.new(1, 2, 'UNKNOWN') }.to raise_error(Robotun::Position::InvalidDirectionError)
      end
    end
  end

  describe "#to_s" do
    it "returns string representation" do
      position = described_class.new(1, 2, "NORTH")
      expect(position.to_s).to eq "1,2,NORTH"
    end
  end

  describe "#==" do
    it "compares x, y and direction" do
      position1 =
      position2 = described_class.new(1, 2, "NORTH")
      expect(described_class.new(1, 2, "NORTH")).to eq described_class.new(1, 2, "NORTH")
      expect(described_class.new(1, 2, "NORTH")).not_to eq described_class.new(2, 2, "NORTH")
      expect(described_class.new(1, 2, "NORTH")).not_to eq described_class.new(1, 1, "NORTH")
      expect(described_class.new(1, 2, "NORTH")).not_to eq described_class.new(1, 1, "SOUTH")
    end
  end
end
