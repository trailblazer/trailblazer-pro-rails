#!/usr/bin/env ruby

require "bundler/setup"
require "rails"
require "action_controller"

require "trailblazer/operation"
require "trailblazer/pro/rails" # FIXME: why do we need this here? can this be done via Gemfile?

module Song
  module Operation
    class Create < Trailblazer::Operation
    end

    class Update < Trailblazer::Operation
    end
  end
end

class App < Rails::Application
  config.root = __dir__
  config.consider_all_requests_local = true
  config.secret_key_base = "i_am_a_secret"
  config.eager_load = false

  # we don't want the trace to be printed on the CLI.
  config.trailblazer.pro.trace_operations = {
    Song::Operation::Create => true
  }

  routes.append do
    root to: "welcome#index"
  end
end

class WelcomeController < ActionController::Base # FIXME: get this from generic top-level class.
  class Http
    def initialize
      @requests = []
    end

    def post(*args, **kws)
      @requests << [args, kws]
      Faraday.post(*args, **kws)
    end

    def to_a
      @requests
    end
  end

  def self.run_create
    Trailblazer::Pro::Session.wtf_present_options.merge!(http: http = Http.new)

    result = Song::Operation::Create.(params: {})

    %([#{result.success?}, #{http.to_a.inspect}]XXX)
  end

  def self.run_update
    result = Song::Operation::Update.(params: {})

    %([#{result.success?}]XXX)
  end
end

App.initialize!

require "rails/commands"
