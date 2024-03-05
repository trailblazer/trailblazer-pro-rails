require_relative "test_helper"

class GeneratorTest < Minitest::Spec
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


      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb g trailblazer:pro:import b0f945 /tmp/b0f945.json", "r+")
      assert_equal cli.readlines.last, %(Diagram b0f945 successfully imported to /tmp/b0f945.json.\n)
      cli.close

      assert File.exist?("/tmp/b0f945.json")
      # TODO: use template from trailblazer-pro test suite.
      assert_equal File.read("/tmp/b0f945.json"), %({\"id\":3,\"type\":\"collaboration\",\"lanes\":[{\"id\":\"lifecycle\",\"type\":\"lane\",\"elements\":[{\"id\":\"Activity_0dgrwre\",\"label\":\"Create\",\"type\":\"task\",\"data\":{},\"links\":[{\"target_id\":\"throw-after-Activity_0dgrwre\",\"semantic\":\"success\"}]},{\"id\":\"catch-before-Activity_0dgrwre\",\"label\":null,\"type\":\"catch_event\",\"data\":{\"start_task\":true},\"links\":[{\"target_id\":\"Activity_0dgrwre\",\"semantic\":\"success\"}]},{\"id\":\"throw-after-Activity_0dgrwre\",\"label\":null,\"type\":\"throw_event\",\"data\":{},\"links\":[]},{\"id\":\"suspend-gw-to-catch-before-Activity_0dgrwre\",\"label\":null,\"type\":\"suspend\",\"data\":{\"resumes\":[\"catch-before-Activity_0dgrwre\"]},\"links\":[]}]}],\"messages\":[]})
    end
  end
end
