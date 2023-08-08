require_relative "test_helper"

# require_relative "../rails_app"

class RailtieTest < Minitest::Spec
  after do
    Dir.chdir("test/dummies/uninitialized") do
      `rm -r tmp/trb-pro`
    end
  end

  let(:api_key) { "tpka_f5c698e2_d1ac_48fa_b59f_70e9ab100604" }
  # let(:trailblazer_pro_host) { "http://localhost:3000" }
  let(:trailblazer_pro_host) { "https://test-pro-rails-jwt.onrender.com" }

  it "allows running {#wtf?} without configuration of PRO" do
    refute File.exist?("tmp/trb-pro/session")

    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb c", "r+")
      cli.write "WelcomeController.run_create_with_wtf?\n"
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

      command = lines.reverse.find { |line| line =~ /WelcomeController\.run_create_with_wtf/ } or raise
      command_index = lines.index(command)

      assert_equal lines[command_index + 1], %(WelcomeController::Create\n) # Trace is here.
      assert_equal lines[command_index + 2], %(|-- \e[32mStart.default\e[0m\n) # Trace is here.

      refute File.exist?("tmp/trb-pro/session")
      # assert_equal File.read("tmp/trb-pro/session"), %({"api_key":"ABC-999","trailblazer_pro_host":"https://pro.trailblazer.to"})
    end
  end

  it "after configuration, you can trace on the web" do
    refute File.exist?("tmp/trb-pro/session")

    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb g trailblazer:pro:install", "r+")
      cli.write "#{api_key}\n"
      cli.close

      json = File.read("tmp/trb-pro/session")
      json = json.sub("https://pro.trailblazer.to", trailblazer_pro_host)
      File.write("tmp/trb-pro/session", json) # FIXME: what do you mean? This is super clean :D

    #@ WTF? traces on web&CLI
      lines, last_line = execute_code_in_rails("WelcomeController.run_create_with_WTF?")

      assert_equal last_line[0..-22], "\e[1m[TRB PRO] view trace (WelcomeController::Create) at \e[22mhttps://ide.trailblazer.to/"

    #@ wtf trace printed per default.
      assert_equal lines[-4], "WelcomeController::Create\n"
      assert_equal lines[-3], "|-- \e[32mStart.default\e[0m\n"

    #@ wtf? traces on CLI

    lines, last_line = execute_code_in_rails("WelcomeController.run_create_with_wtf?")

    # no web trace
    assert_equal lines[-4..-1], [
      "WelcomeController.run_create_with_wtf?\n",
      "WelcomeController::Create\n",
      "|-- \e[32mStart.default\e[0m\n",
      "`-- End.success\n"
    ]

    # Now, check if we reuse id_token
# raise
    # check refresh
    end
  end

  def execute_code_in_rails(command)
    cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb c", "r+")
    cli.write "#{command}\n"

    lines = []
    last_line  = nil

    loop do
      line = cli.gets
      break if line.nil?
      break if line =~ /XXX/

      puts "cli: #{line}"
      last_line = line
      lines << line
    end
    cli.close

    return lines, last_line
  end

  it "you can disable CLI tracing with {render_wtf: false}" do
    Dir.chdir("test/dummies/render_wtf_is_false") do
      # We skip configuring via interactive shell here.
      session_json = %({"api_key":"tpka_f5c698e2_d1ac_48fa_b59f_70e9ab100604","trailblazer_pro_host":"#{trailblazer_pro_host}"})
      json = File.write("tmp/trb-pro/session", session_json)

      lines, last_line = execute_code_in_rails("WelcomeController.run_create_with_WTF?")

      assert_equal last_line[0..-22], "\e[1m[TRB PRO] view trace (WelcomeController::Create) at \e[22mhttps://ide.trailblazer.to/"

    #@ wtf trace not on CLI.
      assert_equal lines[-2], "WelcomeController.run_create_with_WTF?\n"
    end
  end

end
