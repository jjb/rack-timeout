# encoding: UTF-8
require RUBY_VERSION < '1.9' ? 'system_timer' : 'timeout'
SystemTimer ||= Timeout

module Rack
  class Timeout
    @timeout = 15
    class << self
      attr_accessor :timeout
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        SystemTimer.timeout(self.class.timeout, Rack::Timeout::AppTimeout) {
          @app.call(env)
        }
      rescue Rack::Timeout::AppTimeout
        [ 504, {
          "Refresh" => "10",
          "Content-Type" => "text/plain; charset=utf-8"
        }, ["
▄██████████████▄▐█▄▄▄▄█▌
██████▌▄▌▄▐▐▌███▌▀▀██▀▀
████▄█▌▄▌▄▐▐▌▀███▄▄█▌
▄▄▄▄▄██████████████▀

Our systems are over
capacity and could not
complete your requeset.

Your browser will
automatically try again
in 10 seconds.
"
        ]]
      end
    end

    class AppTimeout < ::Timeout::Error; end

  end
end
