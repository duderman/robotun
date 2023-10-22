# frozen_string_literal: true

RSpec.describe Robotun::Parser do
  describe ".parse_line" do
    subject { described_class.parse_line(line) }

    context "when line is empty" do
      let(:line) { "" }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when line is nil" do
      let(:line) { nil }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when line contains only command" do
      let(:line) { "MOVE" }

      it { is_expected.to eq(["MOVE", nil]) }
    end

    context "when line contains command and args" do
      let(:line) { "PLACE 1,2,NORTH" }

      it { is_expected.to eq(["PLACE", %w[1 2 NORTH]]) }
    end

    context "when line contains command and args with spaces" do
      let(:line) { "PLACE  1, 2, NORTH" }

      it { is_expected.to eq(["PLACE", %w[1 2 NORTH]]) }
    end

    context "when line contains command and args with tabs" do
      let(:line) { "PLACE\t1,\t2,\tNORTH" }

      it { is_expected.to eq(["PLACE", %w[1 2 NORTH]]) }
    end

    context "when line contains command and args with mixed spaces and tabs" do
      let(:line) { "PLACE \t 1, \t 2, \t NORTH" }

      it { is_expected.to eq(["PLACE", %w[1 2 NORTH]]) }
    end
  end
end
