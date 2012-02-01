### Overview

Padrino CSRF is a plugin for the [Padrino](https://github.com/padrino/padrino-framework) web framework which adds [cross-site request forgery](http://en.wikipedia.org/wiki/Cross-site_request_forgery) protection.

### Setup & Installation

Include it in your project's `Gemfile` with Bundler:

``` ruby
gem 'padrino-csrf'
```

Modify your `app/app.rb` file to register the plugin:

``` ruby
class ExampleApplication < Padrino::Application
  register Padrino::CSRF
end
```

### Configuration

`prevent_request_forgery`  
When enabled, will automatically verify the CSRF authentication token on all `post`, `put`, and `delete` requests.

You can of course disable this on a request by request basis:

``` ruby
enable :prevent_request_forgery

post :register do
  # request is checked
end

post :register, protect: false do
  # request isn't checked
end
```

Or if you prefer, you can disable it by default, and enable it on a request by request basis:

``` ruby
disable :prevent_request_forgery

post :register do
  # request isn't checked
end

post :register, protect: true do
  # request is checked
end
```

### Dependencies

* [Padrino-Core](https://github.com/padrino/padrino-framework) and [Padrino-Helpers](https://github.com/padrino/padrino-framework)
* [Ruby](http://www.ruby-lang.org/en) >= 1.9.2

### TODO

* Additional documentation
* Tests

### Copyright

Copyright © 2012 Benjamin Bloch (Cirex). See LICENSE for details.