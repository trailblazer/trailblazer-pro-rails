module Trailblazer
  module Pro
    module Rails
      class Railtie < ::Rails::Railtie
        config.trailblazer = ActiveSupport::OrderedOptions.new # TODO: test me with trailblazer-rails
        config.trailblazer.pro = ActiveSupport::OrderedOptions.new
        config.trailblazer.pro.render_wtf = true

        # load session and set Pro::Session.session
        initializer "trailblazer-pro-rails.load_session_and_extend_operation" do
          config.after_initialize do
            Trailblazer::Operation.extend(Pro::Operation::WTF)  # TODO: only apply to selected OPs or make at least configurable?

            config_options = {
              render_wtf: config.trailblazer.pro.render_wtf,
            }

            if File.exist?(Rails::SESSION_PATH)
              # TODO: warn if file not present etc.
              json = File.read(Rails::SESSION_PATH)

              Pro.initialize!(**Session.deserialize(json), **config_options)

              trace_operations = config.trailblazer.pro.trace_operations
              Pro.trace_operations!(trace_operations) if trace_operations

              # TODO: add {Activity.invoke} here, too!
              # Trailblazer::Activity.extend(Pro::Call::Activity) # FIXME: only if allowed! # TODO: only apply to selected OPs.
            else # no configuration happend, yet.
              Pro.initialize!(api_key: "")
            end
          end
        end
      end
    end
  end
end

