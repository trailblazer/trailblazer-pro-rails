module Trailblazer
  module Pro
    module Rails
      class Railtie < ::Rails::Railtie
        # load session and set Pro::Session.session
        initializer "trailblazer-pro-rails.load_session" do
          if File.exist?(Rails::SESSION_PATH)
            # TODO: warn if file not present etc.
            json = File.read(Rails::SESSION_PATH)

            puts "@@@@@ #{Session.deserialize(json).inspect}"
            Pro.initialize!(**Session.deserialize(json))
          end
        end
      end
    end
  end
end
