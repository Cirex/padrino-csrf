# encoding: utf-8
module Padrino
  module CSRF
    module FormHelpers
      ###
      # Returns a hidden HTML input field with this sessions CSRF token
      #
      # @return [String]
      #   Generated HTML for hidden CSRF input field
      #
      # @since 0.1.0
      # @api semipublic
      def token_field_tag
        input_tag(:hidden, name: csrf_param, value: csrf_token)
      end

      # @private
      def form_tag(url, options = {}, &block)
        super(url, options) { token_field_tag + capture_html(&block) }
      end
    end # FormHelpers
  end # CSRF
end # Padrino