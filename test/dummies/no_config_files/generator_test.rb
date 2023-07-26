require_relative "test_helper"

# require_relative "no_config_files"

class GeneratorTest < Minitest::Spec
  after do
    `rm -r tmp/trb-pro`
  end

  it "allows canceling the installation" do
    cli = File.popen("../bin/rails g trailblazer:pro:install", "r+")
    cli.close

    assert_equal File.exist?("tmp/trb-pro"), false
  end

  it "configure API key" do
    cli = File.popen("../bin/rails g trailblazer:pro:install", "r+")
    cli.write "ABC-999\n"
    # raise cli.gets.inspect
    # raise cli.readlines.inspect



    result = Create.wtf?(params: {})

    assert_equal result.success?, true
  end
end
