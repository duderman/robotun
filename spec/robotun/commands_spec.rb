# frozen_string_literal: true

RSpec.describe Robotun::Commands do
  before { allow(Robotun.logger).to receive(:warn) }

  describe ".command_class_for" do
    it "returns command class" do
      expect(described_class.command_class_for("PLACE")).to eq described_class::Place
      expect(described_class.command_class_for("MOVE")).to eq described_class::Move
      expect(described_class.command_class_for("LEFT")).to eq described_class::Left
      expect(described_class.command_class_for("RIGHT")).to eq described_class::Right
      expect(described_class.command_class_for("REPORT")).to eq described_class::Report
    end

    context "with unknown command" do
      it "raises error" do
        expect { described_class.command_class_for("UNKNOWN") }.to raise_error(described_class::UnknownCommandError)
      end
    end
  end

  describe Robotun::Commands::Place do
    let(:field) { Robotun::Field.new(5, 5) }

    describe ".run" do
      subject(:run) { described_class.run(field, current_position, args) }

      let(:current_position) { nil }

      context "when args are valid" do
        let(:args) { %w[1 2 NORTH] }

        it "returns new position" do
          expect(run).to eq(Robotun::Position.new(1, 2, "NORTH"))
        end
      end

      context "when args are invalid" do
        let(:args) { %w[1 2 UNKNOWN] }

        it "returns nil" do
          expect(run).to be_nil
        end
      end

      context "when args are out of bounds" do
        let(:args) { %w[6 6 NORTH] }

        it "returns nil" do
          expect(run).to be_nil
        end

        context "when current position is set" do
          let(:current_position) { Robotun::Position.new(1, 2, "NORTH") }

          it "returns current position" do
            expect(run).to eq(current_position)
          end
        end
      end

      context "when direction in args is lowercase" do
        let(:args) { %w[1 2 north] }

        it "returns new position with upcase direction" do
          expect(run).to eq(Robotun::Position.new(1, 2, "NORTH"))
        end
      end
    end
  end

  describe Robotun::Commands::Move do
    let(:field) { Robotun::Field.new(5, 5) }
    let(:position) { Robotun::Position.new(1, 2, direction) }

    describe ".run" do
      context "when current direction is NORTH" do
        let(:direction) { "NORTH" }

        it "returns new position" do
          expect(described_class.run(field, position)).to eq(Robotun::Position.new(1, 3, "NORTH"))
        end
      end

      context "when current direction is EAST" do
        let(:direction) { "EAST" }

        it "returns new position" do
          expect(described_class.run(field, position)).to eq(Robotun::Position.new(2, 2, "EAST"))
        end
      end

      context "when current direction is SOUTH" do
        let(:direction) { "SOUTH" }

        it "returns new position" do
          expect(described_class.run(field, position)).to eq(Robotun::Position.new(1, 1, "SOUTH"))
        end
      end

      context "when current direction is WEST" do
        let(:direction) { "WEST" }

        it "returns new position" do
          expect(described_class.run(field, position)).to eq(Robotun::Position.new(0, 2, "WEST"))
        end
      end

      context "when position was not set yet" do
        let(:position) { nil }

        it "returns nil" do
          expect(described_class.run(field, position)).to be_nil
        end
      end

      context "when new position is out of bounds" do
        let(:position) { Robotun::Position.new(0, 0, "SOUTH") }

        it "returns nil" do
          expect(described_class.run(field, position)).to eq(position)
        end
      end
    end
  end

  describe Robotun::Commands::Left do
    let(:field) { Robotun::Field.new(5, 5) }
    let(:position) { Robotun::Position.new(1, 2, current_direction) }

    describe ".run" do
      { "NORTH" => "WEST",
        "EAST" => "NORTH",
        "SOUTH" => "EAST",
        "WEST" => "SOUTH" }.each do |current_direction, expected_new_direction|
        context "when current direction is #{current_direction}" do
          let(:current_direction) { current_direction }

          it "returns new position facing #{expected_new_direction}" do
            expect(described_class.run(field, position)).to eq(Robotun::Position.new(1, 2, expected_new_direction))
          end
        end
      end

      context "when position was not set yet" do
        let(:position) { nil }

        it "returns nil" do
          expect(described_class.run(field, position)).to be_nil
        end
      end
    end
  end

  describe Robotun::Commands::Right do
    let(:field) { Robotun::Field.new(5, 5) }
    let(:position) { Robotun::Position.new(1, 2, current_direction) }

    describe ".run" do
      { "NORTH" => "EAST",
        "EAST" => "SOUTH",
        "SOUTH" => "WEST",
        "WEST" => "NORTH" }.each do |current_direction, expected_new_direction|
        context "when current direction is #{current_direction}" do
          let(:current_direction) { current_direction }

          it "returns new position facing #{expected_new_direction}" do
            expect(described_class.run(field, position)).to eq(Robotun::Position.new(1, 2, expected_new_direction))
          end
        end
      end

      context "when position was not set yet" do
        let(:position) { nil }

        it "returns nil" do
          expect(described_class.run(field, position)).to be_nil
        end
      end
    end
  end

  describe Robotun::Commands::Report do
    let(:field) { Robotun::Field.new(5, 5) }
    let(:position) { Robotun::Position.new(1, 2, "NORTH") }

    describe ".run" do
      subject(:run) { described_class.run(field, position) }

      before do
        allow(Robotun.logger).to receive(:info)
      end

      it "returns current position" do
        expect(run).to eq(position)
      end

      it "logs current position" do
        run
        expect(Robotun.logger).to have_received(:info).with("1,2,NORTH")
      end
    end
  end
end
