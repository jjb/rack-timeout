Rack::Timeout
=============

```ruby
<<-CUTE
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
```

Usage
-----

### Installation

You will almost certainly want to make Rack::Timeout the very first middleware.
(The only thing that you might possibly want to put before it is an
exception/error reporter).

```ruby
# config.ru
require 'rack/timeout'
use Rack::Timeout
# ... configuration (see below for options) ...
# ... other middleware ...
run MyApp::Application # if it's a Rails app
```

### Rails 3 app

```ruby
# Gemfile
gem "rack-timeout"

# config/initializers/timeout.rb
Rack::Timeout.time = 10
#... other config
```

### Configuration

Changing the timeout time (default is 15)

```ruby
Rack::Timeout.time = 25
```

Setting a custom handler to report timeouts

```ruby
Rack::Timeout.reporter = lambda{ |exception, env|
  ::Exceptional::Catcher.handle_with_rack(exception, env, Rack::Request.new(env))
}
```

Specifying a custom error page and title

```ruby
Rack::Timeout.error_page = 'http://cdn.example.com/503.html'
Rack::Timeout.error_title = "We're sorry :'-("
```


### Here be dragons

Ruby Timeout relies on threads. If your app or any of the libraries it depends on is
not thread-safe, you may run into issues using rack-timeout.

### TODO

* figure out why when iserted before rack lock and using `Rack::Deflater` results in "Unexpected error while processing request: Attempt to unlock a mutex which is not locked", starting from when I started using the wrapper-thread.
* tidier configuration system
* Figure out who made the text failwhale and give attribution.

---
Copyright © 2012 John Bachir  
Copyright © 2010 Caio Chassot  
released under the MIT license
