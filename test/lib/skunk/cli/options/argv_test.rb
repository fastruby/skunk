# frozen_string_literal: true

require "test_helper"

require "skunk/cli/options/argv"

describe Skunk::Cli::Options::Argv do
  describe "--out path" do
    after do
      Skunk::Config.reset
    end

    it "sets Skunk::Config.root to the provided path" do
      parser = Skunk::Cli::Options::Argv.new(["--out=tmp/custom"])
      parser.parse
      _(Skunk::Config.root).must_match(/tmp\/custom$/)
    end

    it "defaults to tmp/rubycritic when not provided" do
      parser = Skunk::Cli::Options::Argv.new([])
      parser.parse
      _(Skunk::Config.root).must_match(/tmp\/rubycritic$/)
    end
  end

  describe "#formats" do
    after do
      Skunk::Config.reset
    end
    context "passing --formats option" do
      let(:argv) { ["--formats=json,html"] }

      it "applies formats to Skunk::Config" do
        parser = Skunk::Cli::Options::Argv.new(argv)
        parser.parse
        _(Skunk::Config.formats).must_equal %i[json html]
      end
    end
  end
end
