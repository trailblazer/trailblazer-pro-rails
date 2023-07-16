# frozen_string_literal: true

require_relative "rails/version"

module Trailblazer
  module Pro
    module Rails
      SESSION_PATH = "tmp/trb-pro/session"
    end
  end
end

require "rails/generators"
require "trailblazer/pro/rails/railtie"
require "trailblazer/pro/rails/generator"
require "trailblazer/pro/rails/wtf"
require "trailblazer/pro/rails/operation" # TODO: add support for automatic debugging for Activity strategies.
