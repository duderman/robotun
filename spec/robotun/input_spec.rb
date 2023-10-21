# frozen_string_literal: true

RSpec.describe Robotun::Input do
  describe "#each_line" do
    let(:input) { described_class.new }

    before do
      allow(ARGF).to receive(:filename).and_return("data.txt")
    end

    context "when block is given" do
      it "yields each line" do
        allow(ARGF).to receive(:each_line).and_yield("line1").and_yield("line2")
        expect { |b| input.each_line(&b) }.to yield_successive_args("line1", "line2")
      end
    end

    context "when block is not given" do
      it "returns nil" do
        expect(input.each_line).to be_nil
      end
    end

    context "when no data" do
      before do
        allow(ARGF).to receive(:filename).and_return("-")
      end

      it "does nothing" do
        expect { |b| input.each_line(&b) }.not_to yield_control
      end
    end
  end
end
