# encoding: UTF-8
require RUBY_VERSION < '1.9' ? 'system_timer' : 'timeout'
SystemTimer ||= Timeout

module Rack
  class Timeout
    @timeout = 15
    @reporter = lambda do |exception, env|
      puts env.inspect
      puts exception.inspect
    end
    class << self
      attr_accessor :timeout, :reporter
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
        self.class.reporter.call($!, env)
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
