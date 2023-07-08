# frozen_string_literal: true

require_relative "rails/version"

module Trailblazer
  module Pro
    module Rails
      API_KEY_PATH  = "tmp/trb-pro/api_key"
      ID_TOKEN_PATH = "tmp/trb-pro/id_token"
    end
  end
end

# require "rails/generators"
require "trailblazer/pro/rails/generator"
