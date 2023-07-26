require_relative "test_helper"

require_relative "no_config_files"

class RailtieTest < Minitest::Spec
  class Create < Trailblazer::Operation
  end

  it "what" do
    result = Create.wtf?(params: {})

    assert_equal result.success?, true
  end
end
