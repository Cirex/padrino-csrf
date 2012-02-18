PADRINO_ENV = 'test'

require 'rspec'
require 'rspec-html-matchers'
require 'rack/test'
require 'padrino-csrf'

module TestHelpers
  def app
    @app ||= Sinatra.new(Padrino::Application) do
      register Padrino::CSRF
      set :prevent_request_forgery, true
      set :logging, false
    end
  end
end

RSpec.configure do |configuration|
  configuration.include TestHelpers
  configuration.include Rack::Test::Methods
end