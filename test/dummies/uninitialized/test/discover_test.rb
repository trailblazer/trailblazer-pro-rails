require_relative "test_helper"

class DiscoverTest < Minitest::Spec
  include ExecuteInRails

  let(:api_key) { "tpka_909ae987_c834_43e4_9869_2eefd2aa9bcf" }
  let(:trailblazer_pro_host) { "https://testbackend-pro.trb.to" }

  after do
    Dir.chdir("test/dummies/uninitialized") do
      `rm app/concepts/posting/collaboration/state_guards.rb` #if File.exist?("tmp/trb-pro")
      `rm -r app/concepts/posting/collaboration/generated` #if File.exist?("tmp/trb-pro")
    end
  end

  it "retrieve document" do
    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb g trailblazer:pro:install", "r+")
      cli.write "#{api_key}\n"
      cli.close

      json = File.read("tmp/trb-pro/session")
      json = json.sub("https://pro.trailblazer.to", trailblazer_pro_host)
      File.write("tmp/trb-pro/session", json) # FIXME: what do you mean? This is super clean :D

      # Import.
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb g trailblazer:pro:import 79d163 /tmp/79d163.json", "r+")
      assert_equal read_from_cli(cli)[1], %(Diagram 79d163 successfully imported to /tmp/79d163.json.\n)

# TODO: now, we should infer/generate {app/concepts/posting/collaboration/schema.rb}.

      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, %(bin/rails.rb g trailblazer:pro:discover \
/tmp/79d163.json  \
--namespace Posting::Collaboration  \
--test test/posting_collaboration_test.rb \
--start_lane "lifecycle" \
--failure lifecycle:Create,engine:Instantiate --failure lifecycle:Update,engine:Modify \
), "r+")

      assert_equal read_from_cli(cli)[1], %(Discovered 6 states.\n)
      cli.close

      assert File.exist?("app/concepts/posting/collaboration/generated/iteration_set.json")
      assert File.exist?("app/concepts/posting/collaboration/generated/state_table.rb")
      assert File.exist?("app/concepts/posting/collaboration/state_guards.rb")
    end
  end
end
