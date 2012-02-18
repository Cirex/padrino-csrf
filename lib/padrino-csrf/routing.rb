# encoding: utf-8
module Padrino
  module CSRF
    module Routing
      ###
      # Routing condition which lets you manually toggle CSRF authentication
      #
      # @param [Boolean] protect
      #   Should the request be authenticated
      #
      # @raise [InvalidToken]
      #   Raised when the CSRF parameter is invalid
      #
      # @example
      #   enable :prevent_request_forgery
      #
      #   post :register do
      #     # request is checked
      #   end
      #
      #   post :register, protect: false do
      #     # request isn't checked
      #   end
      #
      # @example
      #   disable :prevent_request_forgery
      #
      #   post :register do
      #     # request isn't checked
      #   end
      #
      #   post :register, protect: true do
      #     # request is checked
      #   end
      #
      # @since 0.1.0
      # @api public
      def protect(protect = false)
        condition do
          if protect
            raise InvalidToken unless csrf_valid?
          end
        end
      end

      # @private
      def route(verb, path, options = {}, &block)
        if REQUEST_BLACKLIST.include?(verb)
          if options[:protect].nil?
             options[:protect] = settings.prevent_request_forgery if settings.prevent_request_forgery?
          end
        else
          options.delete :protect
        end

        super(verb, path, options, &block)
      end
    end # Routing
  end # CSRF
end # Padrino