module Trailblazer
  module Pro
    module Rails
      module Operation
        module Wtf
          def wtf?(options)
            # I'd prefer if we could call super here, this is not a nice monkey-patch.
            call_with_public_interface(options, {}, invoke_class: Rails::Wtf)
          end
        end
      end
    end
  end
end
