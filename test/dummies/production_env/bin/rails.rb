#!/usr/bin/env ruby

require "bundler/setup"
require "rails"
require "action_controller"

require "trailblazer/operation"
require "trailblazer/pro/rails" # FIXME: why do we need this here? can this be done via Gemfile?

# Production app with {eager_load}.
class App < Rails::Application
  config.root = __dir__

  config.eager_load_paths = ["#{config.root}/../app/controllers", "#{config.root}/../app/concepts"]
  config.eager_load = true

  config.consider_all_requests_local = true
  config.secret_key_base = "i_am_a_secret"

  # we don't want the trace to be printed on the CLI.
  config.trailblazer.pro.trace_operations = {
    # "WelcomeController" => true,
    "Create" => true
  }
end

App.initialize!

require "rails/commands"
