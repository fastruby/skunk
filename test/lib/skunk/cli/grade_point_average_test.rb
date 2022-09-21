# frozen_string_literal: true

# |Letter Grade | Percent Grade | Scale |
# |:------------|:-------------:|------:|
# | A+          | Below 65      | 4.0   |
# | A           | 65-66         | 4.0   |
# | A-          | 67-69         | 3.7   |
# | B+          | 70-72         | 3.3   |
# | B           | 73-76         | 3.0   |
# | B-          | 77-79         | 2.7   |
# | C+          | 80-82         | 2.3   |
# | C           | 83-86         | 2.0   |
# | C-          | 87-89         | 1.7   |
# | D+          | 90-92         | 1.3   |
# | D           | 93-96         | 1.0   |
# | E/F         | 97-100        | 0.0   |

require "test_helper"

require "skunk/cli/grade_point_average"

describe Skunk::Cli::GradePointAverage do
  subject { Skunk::Cli::GradePointAverage }

  describe "#score" do
    context "with A score" do
      it { expect(subject.new(0).score).must_equal "A+" }
      it { expect(subject.new(65).score).must_equal "A" }
      it { expect(subject.new(66).score).must_equal "A" }
      it { expect(subject.new(67).score).must_equal "A-" }
      it { expect(subject.new(69).score).must_equal "A-" }
    end

    context "with B score" do
      it { expect(subject.new(70).score).must_equal "B+" }
      it { expect(subject.new(72).score).must_equal "B+" }
      it { expect(subject.new(73).score).must_equal "B" }
      it { expect(subject.new(76).score).must_equal "B" }
      it { expect(subject.new(77).score).must_equal "B-" }
      it { expect(subject.new(79).score).must_equal "B-" }
    end

    context "with C score" do
      it { expect(subject.new(80).score).must_equal "C+" }
      it { expect(subject.new(82).score).must_equal "C+" }
      it { expect(subject.new(83).score).must_equal "C" }
      it { expect(subject.new(86).score).must_equal "C" }
      it { expect(subject.new(87).score).must_equal "C-" }
      it { expect(subject.new(89).score).must_equal "C-" }
    end

    context "with D score" do
      it { expect(subject.new(90).score).must_equal "D+" }
      it { expect(subject.new(92).score).must_equal "D+" }
      it { expect(subject.new(93).score).must_equal "D" }
      it { expect(subject.new(96).score).must_equal "D" }
    end

    context "with E score" do
      it { expect(subject.new(97).score).must_equal "E" }
      it { expect(subject.new(1000).score).must_equal "E" }
      it { expect(subject.new(10_000).score).must_equal "E" }
    end
  end
end
