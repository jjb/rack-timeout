Rack::Timeout
=============

Abort requests that are taking too long; a Timeout::Error will be raised.


Usage
-----

### Rails 3 app or Rails 2.3 app with Bundler

    # Gemfile
    gem "SystemTimer", :require => "system_timer", :platforms => :ruby_18
    gem "rack-timeout"


### Rails 2.3 app without Bundler

    # config/environment.rb
    config.gem "SystemTimer", :lib => "system_timer" if RUBY_VERSION < "1.9"
    config.gem "rack-timeout"


### Sinatra and other Rack apps

    # config.ru
    require 'rack/timeout'
    use Rack::Timeout
    Rack::Timeout.timeout = 10  # this line is optional. if omitted, default is 15 seconds.


### Setting a custom timeout for Rails apps

    # config/initializers/timeout.rb
    Rack::Timeout.timeout = 10  # seconds


### Setting a custom handler to report timeouts

    # config/initializers/timeout.rb
	Rack::Timeout.reporter = lambda{ |exception, env|
	  ::Exceptional::Catcher.handle_with_rack(exception, env, Rack::Request.new(env))
	}

### Here be dragons

SystemTimer/timeout rely on threads. If your app or any of the libraries it depends on is
not thread-safe, you may run into issues using rack-timeout.


---
Copyright © 2010 Caio Chassot, released under the MIT license
<http://github.com/kch/rack-timeout>
