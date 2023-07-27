require_relative "test_helper"

# require_relative "../rails_app"

class RailtieTest < Minitest::Spec
  after do
    Dir.chdir("test/dummies/uninitialized") do
      `rm -r tmp/trb-pro`
    end
  end

  it "allows running {#wtf?} without configuration of PRO" do
    refute File.exist?("tmp/trb-pro/session")

    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails c", "r+")
      cli.write "WelcomeController.run_create\n"
      # require "io/wait"
      # cli.wait(nil, :read)
      lines = [
        cli.gets,
        cli.gets,
        cli.gets,
        cli.gets,
        cli.gets,
        cli.gets,
        cli.gets,
      ]
      # out = cli.gets
      cli.close
      puts lines

      command = lines.find { |line| line =~ /WelcomeController\.run_create/ } or raise
      command_index = lines.index(command)

      assert_equal lines[command_index + 1], %(WelcomeController::Create\n) # Trace is here.

      refute File.exist?("tmp/trb-pro/session")
      # assert_equal File.read("tmp/trb-pro/session"), %({"api_key":"ABC-999","trailblazer_pro_host":"https://pro.trailblazer.to"})
    end
  end

end
