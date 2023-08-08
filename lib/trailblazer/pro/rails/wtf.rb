module Trailblazer
  module Pro
    module Rails
      # Save the session in tmp/ if it changed after invocation.
      module Wtf
        extend Pro::Trace::Wtf
        module_function

        def call(*args, present_options: {}, **options)
          returned = super(*args, present_options: present_options, **options)

          (session, trace_id, debugger_url, _trace_envelope, session_updated) = returned[-1]

          if session_updated
            File.write(Rails::SESSION_PATH, Session.serialize(session)) # DISCUSS: redundant
          end

          returned
        end

        # alias invoke call
        singleton_class.alias_method :invoke, :call
      end
    end
  end
end
