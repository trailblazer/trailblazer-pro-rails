require_relative "test_helper"

class ImportTest < Minitest::Spec
  include ExecuteInRails

  let(:api_key) { "tpka_909ae987_c834_43e4_9869_2eefd2aa9bcf" }
  let(:trailblazer_pro_host) { "https://testbackend-pro.trb.to" }

  after do
    # Dir.chdir("test/dummies/uninitialized") do
    #   `rm tmp/trb-pro` #if File.exist?("tmp/trb-pro")
    # end
    `rm /tmp/b0f945.json`
  end

  it "retrieve document" do
    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb g trailblazer:pro:install", "r+")
      cli.write "#{api_key}\n"
      cli.close

      json = File.read("tmp/trb-pro/session")
      json = json.sub("https://pro.trailblazer.to", trailblazer_pro_host)
      File.write("tmp/trb-pro/session", json) # FIXME: what do you mean? This is super clean :D


      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb g trailblazer:pro:import 79d163 /tmp/79d163.json", "r+")
      assert_equal read_from_cli(cli)[1], %(Diagram 79d163 successfully imported to /tmp/79d163.json.\n)
      cli.close

      assert File.exist?("/tmp/79d163.json")
      # TODO: use template from trailblazer-pro test suite.
      File.read("/tmp/79d163.json")
      assert_equal File.read("/tmp/79d163.json"), %()
    end
  end
end
