require "test_helper"
require "generators/pro/pro_generator"

class ProGeneratorTest < Rails::Generators::TestCase
  tests ProGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
