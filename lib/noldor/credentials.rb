# frozen_string_literal: true

module Noldor
  class Credentials
    attr_reader :api_base
    attr_accessor :api_key, :exception_enabled

    def initialize
      @api_base = 'https://the-one-api.dev/v2/'
      @api_key = ''
      @exception_enabled = true
    end

    def set_test_mode(test)
      host = URI.parse(api_base).host

      if test == true
        @api_base = "https://test-#{host}" unless host.start_with?('test-')
      elsif host.start_with?('test-')
        @api_base = "https://#{host[5..-1]}"
      end
    end
  end
end
