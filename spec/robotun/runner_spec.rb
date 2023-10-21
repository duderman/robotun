# frozen_string_literal: true

RSpec.describe Robotun::Runner do
  describe "#run" do
    subject(:run) { runner.run }

    let(:input) { instance_double(Robotun::Input) }
    let(:output) { Robotun::Output.new }
    let(:runner) { described_class.new(input) }

    before do
      allow(input).to receive(:each_line).and_yield("PLACE 1,2,NORTH").and_yield("MOVE").and_yield("REPORT")
      allow(Robotun.logger).to receive(:info)
    end

    it "runs commands one by one" do
      run
      expect(Robotun.logger).to have_received(:info).with("1,3,NORTH")
    end
  end
end
