# frozen_string_literal: true

require "test_helper"

require "skunk/cli/options/argv"

describe Skunk::Cli::Options::Argv do
  describe "--out path" do
    before do
      @prior_root = RubyCritic::Config.root
    end

    after do
      RubyCritic::Config.root = @prior_root if @prior_root
      Skunk::Config.reset
    end

    it "sets Skunk::Config.root to the provided path" do
      parser = Skunk::Cli::Options::Argv.new(["--out=tmp/custom"])
      parser.parse
      _(Skunk::Config.root).must_match(%r{tmp/custom$})
    end

    it "defaults to tmp/rubycritic when not provided" do
      default_root = File.expand_path("tmp/rubycritic_default", Dir.pwd)
      RubyCritic::Config.root = default_root
      Skunk::Config.reset
      parser = Skunk::Cli::Options::Argv.new([])
      parser.parse
      _(Skunk::Config.root).must_equal default_root
    end
  end

  describe "#formats" do
    before do
      Skunk::Config.reset
    end

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

    context "not passing --formats option" do
      it "defaults to console format" do
        parser = Skunk::Cli::Options::Argv.new([])
        parser.parse
        _(Skunk::Config.formats).must_equal [:console]
      end
    end
  end
end
