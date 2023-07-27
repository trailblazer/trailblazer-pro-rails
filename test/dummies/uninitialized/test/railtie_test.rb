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
      lines = [
        cli.gets,
        cli.gets,
        cli.gets,
        cli.gets,
        cli.gets,
        cli.gets,
        cli.gets,
      ]
      # out = cli.gets # FIXME: this will block infinitely if there's no more line coming from the stream. if you can fix that for us, please do.
      cli.close
      puts lines

      command = lines.find { |line| line =~ /WelcomeController\.run_create/ } or raise
      command_index = lines.index(command)

      assert_equal lines[command_index + 1], %(WelcomeController::Create\n) # Trace is here.
      assert_equal lines[command_index + 2], %(|-- \e[32mStart.default\e[0m\n) # Trace is here.

      refute File.exist?("tmp/trb-pro/session")
      # assert_equal File.read("tmp/trb-pro/session"), %({"api_key":"ABC-999","trailblazer_pro_host":"https://pro.trailblazer.to"})
    end
  end

  it "after configuration, you can trace on the web" do
    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails g trailblazer:pro:install", "r+")
      cli.write "tpka_f5c698e2_d1ac_48fa_b59f_70e9ab100604\n"
      cli.close

      json = File.read("tmp/trb-pro/session")
      json = json.sub("https://pro.trailblazer.to", "http://localhost:3000")
      File.write("tmp/trb-pro/session", json) # FIXME: what do you mean? This is super clean :D

      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails c", "r+")
      cli.write "WelcomeController.run_create\n"

      line = nil
      loop do
        line = cli.gets
        break if line =~ /\[TRB PRO]/
      end
      cli.close

      puts "@@@@@ #{line.inspect}"

      assert_equal line[0..-22], "[TRB PRO] view trace at https://ide.trailblazer.to/"
    end
  end

end
