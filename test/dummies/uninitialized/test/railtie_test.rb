require_relative "test_helper"

require_relative "../rails_app"

class RailtieTest < Minitest::Spec
  class Create < Trailblazer::Operation
  end

  it "allows running {#wtf?} without configuration of PRO" do
    result = Create.wtf?(params: {})

    assert_equal result.success?, true
  end
end
