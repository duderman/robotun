RSpec.describe Robotun::Runner do
  describe "#run" do
    let(:input) { double(Robotun::Input) }
    let(:output) { Robotun::Output.new }
    let(:runner) { described_class.new(input) }

    before do
      allow(input).to receive(:each_line).and_yield("PLACE 1,2,NORTH").and_yield("MOVE").and_yield("REPORT")
    end

    it "runs commands" do
      expect(Robotun.logger).to receive(:info).with("1,3,NORTH")
      runner.run
    end
  end
end
