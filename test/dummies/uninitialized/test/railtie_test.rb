require_relative "test_helper"

# require_relative "../rails_app"

class RailtieTest < Minitest::Spec
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

      break if line[0..11] == "\tfrom (irb):" # detect exceptions, stop reading. Otherwise {#gets} will never return.
    end
    cli.close

    return lines, last_line
  end

  after do
    Dir.chdir("test/dummies/uninitialized") do
      `rm -r tmp/trb-pro`
    end
  end

  let(:api_key) { "tpka_909ae987_c834_43e4_9869_2eefd2aa9bcf" }
  # let(:trailblazer_pro_host) { "http://localhost:3000" }
  let(:trailblazer_pro_host) { "https://testbackend-pro.trb.to" }

  it "allows running {#wtf?} without configuration of PRO" do
    refute File.exist?("tmp/trb-pro/session")

    Dir.chdir("test/dummies/uninitialized") do
      lines, last_line = execute_code_in_rails("WelcomeController.run_create_with_wtf?")

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

  it "you can disable CLI tracing with {render_wtf: false}" do
    Dir.chdir("test/dummies/render_wtf_is_false") do
      # We skip configuring via interactive shell here.
      session_json = %({"api_key":"#{api_key}","trailblazer_pro_host":"#{trailblazer_pro_host}"})
      json = File.write("tmp/trb-pro/session", session_json)

      lines, last_line = execute_code_in_rails("WelcomeController.run_create_with_WTF?")

      assert_equal last_line[0..-22], "\e[1m[TRB PRO] view trace (WelcomeController::Create) at \e[22mhttps://ide.trailblazer.to/"

    #@ wtf trace not on CLI.
      assert_equal lines[-2], "WelcomeController.run_create_with_WTF?\n"
    end
  end

  it "allows configuration of trace strategy via {config}" do
    Dir.chdir("test/dummies/configured") do
      # We skip configuring via interactive shell here.
      session_json = %({"api_key":"#{api_key}","trailblazer_pro_host":"#{trailblazer_pro_host}"})
      json = File.write("tmp/trb-pro/session", session_json)

      lines, last_line = execute_code_in_rails("WelcomeController.run_create")

      # CLI and web tracing for {Song::Operation::Create}
      assert_equal lines[-4], "Song::Operation::Create\n"
      assert_equal lines[-3], "|-- \e[32mStart.default\e[0m\n"
      assert_equal lines[-2], "`-- End.success\n"
      assert_equal last_line[0..-22], "\e[1m[TRB PRO] view trace (Song::Operation::Create) at \e[22mhttps://ide.trailblazer.to/"

      # no automatic tracing {Song::Operation::Update}
      lines, last_line = execute_code_in_rails("WelcomeController.run_update")

      assert_equal lines.size, 3 # no tracing at all!
      assert_equal last_line, "WelcomeController.run_update\n"
    end
  end

  it "allows configuring {trace_operations} in production" do
    Dir.chdir("test/dummies/production_env") do
      # We skip configuring via interactive shell here.
      session_json = %({"api_key":"#{api_key}","trailblazer_pro_host":"#{trailblazer_pro_host}"})
      json = File.write("tmp/trb-pro/session", session_json)

      lines, last_line = execute_code_in_rails("WelcomeController.run_create")

      # CLI and web tracing for {Song::Operation::Create}
      assert_equal lines[-4], "Create\n"
      assert_equal lines[-3], "|-- \e[32mStart.default\e[0m\n"
      assert_equal lines[-2], "`-- End.success\n"
      assert_equal last_line[0..-22], "\e[1m[TRB PRO] view trace (Create) at \e[22mhttps://ide.trailblazer.to/"
    end
  end

  it "raises exception with incorrect credentials" do
    refute File.exist?("tmp/trb-pro/session")

    Dir.chdir("test/dummies/uninitialized") do
      cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb g trailblazer:pro:install", "r+")
      cli.write "XXX_#{api_key}\n"
      cli.close

      json = File.read("tmp/trb-pro/session")
      json = json.sub("https://pro.trailblazer.to", trailblazer_pro_host)
      File.write("tmp/trb-pro/session", json) # FIXME: what do you mean? This is super clean :D

      lines, last_line = execute_code_in_rails("WelcomeController.run_create_with_WTF?")

      assert_equal lines[-2], %(RuntimeError ("Custom token couldn't be retrieved. HTTP status: 401")\n)
    end
  end
end
