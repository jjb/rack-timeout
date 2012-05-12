require File.join(File.expand_path(File.dirname(__FILE__)), 'rack/timeout')

if defined?(Rails) && 3 == Rails::VERSION::MAJOR
  class Rack::Timeout::Railtie < Rails::Railtie
    initializer("rack-timeout.insert-rack-timeout") { |app| app.config.middleware.use Rack::Timeout }
  end
end
