module Trailblazer
  module Pro
    module Rails
      class Railtie < ::Rails::Railtie
        # load session and set Pro::Session.session
        initializer "trailblazer-pro-rails.load_session_and_extend_operation" do
          if File.exist?(Rails::SESSION_PATH)
            # TODO: warn if file not present etc.
            json = File.read(Rails::SESSION_PATH)

            Pro.initialize!(**Session.deserialize(json))

            Trailblazer::Operation.extend(Trailblazer::Pro::Rails::Operation::Wtf) # Override {Operation.wtf?} so it pushes traces.
          else # no configuration happend, yet.
            # Pro.initialize!(api_key: "")
          end
        end
      end
    end
  end
end

