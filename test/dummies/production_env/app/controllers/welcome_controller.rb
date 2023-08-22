class WelcomeController < ActionController::Base # FIXME: get this from generic top-level class.
  class Http
    def initialize
      @requests = []
    end

    def post(*args, **kws)
      @requests << [args, kws]
      Faraday.post(*args, **kws)
    end

    def to_a
      @requests
    end
  end

  def self.run_create
    Trailblazer::Pro::Session.wtf_present_options.merge!(http: http = Http.new)

    result = Create.(params: {})

    %([#{result.success?}, #{http.to_a.inspect}]XXX)
  end
end
