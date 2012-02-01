# encoding: utf-8
module Padrino
  module CSRF
   module Helpers
      ###
      # Returns whether or not the CSRF parameter is authentic
      #
      # @return [Boolean]
      #   *true* if CSRF is valid, *false* otherwise
      #
      # @since 0.1.0
      # @api semipublic
      def csrf_valid?
        csrf_token == params[csrf_param] || csrf_token == request.env['HTTP_X_CSRF_TOKEN']
      end

      ###
      # Returns HTML meta tags for use with unobtrusive javascript helpers
      #
      # @return [String]
      #   Generated HTML for CSRF meta tags
      #
      # @example
      #   csrf_meta_tags
      #   # => <meta name="csrf-token" content="71ab53190d2f863b5f3b12381d2d5986512f8e15b34d439e6b66e3daf41b5e35">
      #   # => <meta name="csrf-param" content="_csrf_token">
      #
      # @since 0.1.0
      # @api public
      def csrf_meta_tags
        [ meta_tag(csrf_token, name: 'csrf-token'),
          meta_tag(csrf_param, name: 'csrf-param')
        ].join("\n")
      end

      ###
      # Returns the CSRF authentication token for the current session
      #
      # @return [String]
      #   32 character CSRF token
      #
      # @since 0.1.0
      # @api semipublic
      def csrf_token
        session[csrf_param] ||= SecureRandom.hex(32)
      end

      # @private
      def csrf_param
        :_csrf_token
      end
    end # Helpers
  end # CSRF
end # Padrino