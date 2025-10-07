# frozen_string_literal: true

require "test_helper"

require "skunk/generators/html/path_truncator"

# rubocop:disable Metrics/BlockLength
describe Skunk::Generator::Html::PathTruncator do
  describe ".truncate" do
    context "when path contains app folder" do
      it "truncates to show from app folder onwards" do
        path = "/Users/juan/code/project/app/services/dummy_service.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "app/services/dummy_service.rb"
      end
    end

    context "when path contains lib folder" do
      it "truncates to show from lib folder onwards" do
        path = "/Users/juan/code/project/lib/skunk/generators/html/overview.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "lib/skunk/generators/html/overview.rb"
      end
    end

    context "when path contains spec folder" do
      it "truncates to show from spec folder onwards" do
        path = "/Users/juan/code/project/spec/skunk/generators/html_report_spec.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "spec/skunk/generators/html_report_spec.rb"
      end
    end

    context "when path contains test folder" do
      it "truncates to show from test folder onwards" do
        path = "/Users/juan/code/project/test/lib/skunk/generators/html/path_truncator_test.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "test/lib/skunk/generators/html/path_truncator_test.rb"
      end
    end

    context "when path contains src folder" do
      it "truncates to show from src folder onwards" do
        path = "/Users/juan/code/project/src/components/header.js"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "src/components/header.js"
      end
    end

    context "when path contains features folder" do
      it "truncates to show from features folder onwards" do
        path = "/Users/juan/code/project/features/user_authentication.feature"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "features/user_authentication.feature"
      end
    end

    context "when path contains db folder" do
      it "truncates to show from db folder onwards" do
        path = "/Users/juan/code/project/db/migrate/20231201_create_users.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "db/migrate/20231201_create_users.rb"
      end
    end

    context "when path is already relative" do
      it "returns the path unchanged" do
        path = "app/services/dummy_service.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "app/services/dummy_service.rb"
      end
    end

    context "when path is already relative with lib folder" do
      it "returns the path unchanged" do
        path = "lib/skunk/generators/html/overview.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "lib/skunk/generators/html/overview.rb"
      end
    end

    context "when path does not contain any project folders" do
      it "returns the original path" do
        path = "/Users/juan/Documents/random_file.txt"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "/Users/juan/Documents/random_file.txt"
      end
    end

    context "when path is empty string" do
      it "returns empty string" do
        path = ""
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal ""
      end
    end

    context "when path is nil" do
      it "returns nil" do
        path = nil
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_be_nil
      end
    end

    context "when path is a Pathname object" do
      it "converts to string and truncates correctly" do
        require "pathname"
        path = Pathname.new("/Users/juan/code/project/app/services/dummy_service.rb")
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "app/services/dummy_service.rb"
      end
    end

    context "when multiple project folders exist" do
      it "truncates from the first project folder found" do
        path = "/Users/juan/code/project/app/lib/services/dummy_service.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "app/lib/services/dummy_service.rb"
      end
    end

    context "when path has nested project structure" do
      it "truncates from the first project folder" do
        path = "/Users/juan/code/project/app/services/free/my_service.rb"
        result = Skunk::Generator::Html::PathTruncator.truncate(path)

        _(result).must_equal "app/services/free/my_service.rb"
      end
    end
  end

  describe "#initialize" do
    it "stores the file path" do
      path = "/Users/juan/code/project/app/services/dummy_service.rb"
      truncator = Skunk::Generator::Html::PathTruncator.new(path)

      _(truncator.instance_variable_get(:@file_path)).must_equal path
    end
  end

  describe "#truncate" do
    let(:path) { "/Users/juan/code/project/app/services/dummy_service.rb" }
    let(:truncator) { Skunk::Generator::Html::PathTruncator.new(path) }

    it "returns the truncated path" do
      result = truncator.truncate

      _(result).must_equal "app/services/dummy_service.rb"
    end
  end

  describe "PROJECT_FOLDERS constant" do
    it "contains the expected project folder names" do
      expected_folders = %w[app lib src test spec features db]

      _(Skunk::Generator::Html::PathTruncator::PROJECT_FOLDERS).must_equal expected_folders
    end

    it "is frozen" do
      _(Skunk::Generator::Html::PathTruncator::PROJECT_FOLDERS).must_be :frozen?
    end
  end
end
# rubocop:enable Metrics/BlockLength
