module Trailblazer

  module Pro
    class Install < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_session_file
        create_file Rails::SESSION_PATH do
          input = ask %(Your Trailblazer PRO API key:)

          uninitialized_session = Trailblazer::Pro::Session::Uninitialized.new(api_key: input, trailblazer_pro_host: "https://pro.trailblazer.to")
          Trailblazer::Pro::Session.serialize(uninitialized_session)
        end
      end
    end
  end
end
