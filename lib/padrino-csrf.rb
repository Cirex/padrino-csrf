# encoding: utf-8
require 'padrino-core'
require 'padrino-helpers'

FileSet.glob_require('padrino-csrf/**/*.rb', __FILE__)

module Padrino
  module CSRF
    REQUEST_BLACKLIST = %w(POST PUT DELETE)

    class InvalidToken < RuntimeError
      def http_status
        403
      end
    end

    class << self
      # @private
      def registered(app)
        app.helpers Helpers
        app.helpers FormHelpers
        app.enable :prevent_request_forgery

        app.extend Routing

        if defined?(Padrino::Assets)
          Padrino::Assets.load_paths << File.expand_path('../../vendor/assets', __FILE__)
          app.precompile_assets << 'jquery.unobtrusive.js'
        end
      end
    end # self
  end # CSRF
end # Padrino