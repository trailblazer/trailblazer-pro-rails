module Trailblazer

  module Pro
    class Install < ::Rails::Generators::Base
      # source_root File.expand_path("templates", __dir__)

      def prompt_for_api_key
        input = ask %(Your Trailblazer PRO API key:)
        # TODO: blank
        return if input.blank?

        @api_key = input.chomp
      end

      def create_session_file
        return if @api_key.nil? # FIXME: use Trailblazer instead of thor's basic control flow.

        create_file Rails::SESSION_PATH do
          uninitialized_session = Trailblazer::Pro::Session::Uninitialized.new(api_key: @api_key, trailblazer_pro_host: "https://pro.trailblazer.to")

          Trailblazer::Pro::Session.serialize(uninitialized_session)
        end
      end
    end
  end
end
