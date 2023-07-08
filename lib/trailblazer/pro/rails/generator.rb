module Trailblazer

  module Pro
    class Install < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def a
        create_file Rails::API_KEY_PATH do
          input = ask %(Your Trailblazer PRO API key:)
        end

        create_file Rails::ID_TOKEN_PATH
      end
    end
  end
end
