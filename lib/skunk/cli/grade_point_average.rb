# frozen_string_literal: true

module Skunk
  module Cli
    # Knows how to calculate GPA score
    class GradePointAverage
      def initialize(skunk_score)
        @skunk_score = skunk_score
      end

      def score # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
        case @skunk_score
        when (0..64)
          "A+"
        when (65..66)
          "A"
        when (67..69)
          "A-"
        when (70..72)
          "B+"
        when (73..76)
          "B"
        when (77..79)
          "B-"
        when (80..82)
          "C+"
        when (83..86)
          "C"
        when (87..89)
          "C-"
        when (90..92)
          "D+"
        when (93..96)
          "D"
        when (93..Float::INFINITY)
          "E"
        end
      end
    end
  end
end
