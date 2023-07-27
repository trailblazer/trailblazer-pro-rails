require_relative "test_helper"

# require_relative "no_config_files"

class GeneratorTest < Minitest::Spec
  after do
    `rm -r tmp/trb-pro` #if File.exist?("tmp/trb-pro")
  end

  it "allows canceling the installation" do
    cli = File.popen("../bin/rails g trailblazer:pro:install", "r+")
    cli.close

    # we don't leave any assets behind when canceling the installation
    refute File.exist?("tmp/trb-pro")
  end

  it "configure API key" do
    cli = File.popen("../bin/rails g trailblazer:pro:install", "r+")
    cli.write "ABC-999\n"
    cli.close

    assert File.exist?("tmp/trb-pro/session")
    assert_equal File.read("tmp/trb-pro/session"), %({"api_key":"ABC-999","trailblazer_pro_host":"https://pro.trailblazer.to"})
  end
end
