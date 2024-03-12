$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"

module ExecuteInRails
  def execute_in_rails(command)
    cli = File.popen({"BUNDLE_GEMFILE" => "../Gemfile"}, "bin/rails.rb c", "r+")
    cli.write "#{command}\n"

    lines, last_line = read_from_cli(cli)

    cli.close

    return lines, last_line
  end

  def read_from_cli(io)
    lines = []
    last_line  = nil

    loop do
      line = io.gets
      break if line.nil?
      break if line =~ /XXX/

      puts "cli: #{line}"
      last_line = line
      lines << line

      break if line[0..11] == "\tfrom (irb):" # detect exceptions, stop reading. Otherwise {#gets} will never return.
    end

    return lines, last_line
  end
end
