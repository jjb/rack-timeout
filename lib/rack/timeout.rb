# encoding: UTF-8
require 'timeout'

module Rack
  class Timeout
    class AppTimeout < ::Timeout::Error; end

    @timeout = 15
    @reporter = lambda do |exception, env|
      puts env.inspect
      puts exception.inspect
    end
    @error_page = nil
    @error_title = 'sorry.'
    class << self
      attr_accessor :time, :reporter, :error_page, :error_title
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      t = nil
      begin
        ::Timeout.timeout(self.class.time, Rack::Timeout::AppTimeout) {
          t = Thread.new{ @app.call(env) }
          t.value
        }
      rescue Rack::Timeout::AppTimeout
        self.class.reporter.call($!, env)

        if self.class.error_page
          html_response
        else
          text_response
        end
      ensure
        # This is what Timeout.timeout does. I guess that means it's the
        # safest method. I don't know why join would ever be needed
        # after kill.
        t.kill
        t.join
      end

    end

    private

    def text_response
      [ 503, {
        "Refresh" => "10",
        "Content-Type" => "text/plain; charset=utf-8"
      }, [<<-CUTE
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
CUTE
      ]]      
    end

    def html_response
      [ 503, {
        "Refresh" => "10",
        "Content-Type" => "text/html; charset=utf-8"
      }, [<<-HTML
<!DOCTYPE html>
<head>
  <title>#{self.class.error_title}</title>
</head>
<body>
  <iframe width="100%" height="1600" scrolling="no" frameborder="0"
          src="#{self.class.error_page}">
  </iframe>
</body>
HTML
      ]]
    end


  end
end
