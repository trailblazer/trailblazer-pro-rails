require_relative "test_helper"

class GeneratorTest < Minitest::Spec
  after do
    Dir.chdir("test/dummies/uninitialized") do
      `rm -r tmp/trb-pro` #if File.exist?("tmp/trb-pro")
    end
  end

  it "allows canceling the installation" do
    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bundle exec bin/rails.rb g trailblazer:pro:install", "r+")
      cli.close

      # we don't leave any assets behind when canceling the installation
      refute File.exist?("tmp/trb-pro")
    end
  end

  it "configure API key" do
    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb g trailblazer:pro:install", "r+")
      cli.write "ABC-999\n"
      cli.close

      assert File.exist?("tmp/trb-pro/session")
      assert_equal File.read("tmp/trb-pro/session"), %({"api_key":"ABC-999","trailblazer_pro_host":"https://pro.trailblazer.to"})
    end
  end
end
