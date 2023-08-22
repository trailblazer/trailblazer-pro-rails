#!/usr/bin/env ruby

require "bundler/setup"
require "rails"
require "action_controller"

require "trailblazer/operation"
require "trailblazer/pro/rails" # FIXME: why do we need this here? can this be done via Gemfile?

class App < Rails::Application
  config.eager_load_paths = [File.expand_path("./app/controllers", "./app/concepts")]

  config.root = __dir__
  config.consider_all_requests_local = true
  config.secret_key_base = "i_am_a_secret"
  config.eager_load = true

  # we don't want the trace to be printed on the CLI.
  config.trailblazer.pro.trace_operations = {
    "Create" => true
  }
end



App.initialize!
App.eager_load!

require "rails/commands"
