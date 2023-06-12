# frozen_string_literal: true

require 'singleton'
require 'faraday'
require 'faraday_middleware'

module Noldor
  module Http
    class Request
      include Singleton

      def initialize; end

      # Sends a request to the third party API and returns a formatted response to the caller
      # example: send_http(method: 'GET', path: '/home', resource_class: Noldor::Home, options: { limit: 12 })
      # 
      #
      def send_http(method:, path:, resource_class:, options: {})
        raise ArgumentError, 'Invalid url format' unless path.is_a? String

        headers = options[:headers] || {}
        payload = options[:payload] || {}
        params = options[:params] || {}
        timeout = options[:timeout] || 30

        connection = configure_connection(headers: headers, timeout: timeout, params: params)

        response = connection.public_send(method.downcase.to_sym, path, payload)
        body = response.body
        status = response.status

        if [400, 404].include?(status)
          raise Noldor::Exceptions::InvalidRequest,
                "Invalid request, status code: #{status}"
        end

        raise Noldor::Exceptions::Base, body if status < 200 || status > 299

        Noldor::Http::Response.new(response: response, klass: resource_class).response
      rescue Faraday::ClientError => e
        raise Noldor::Exceptions::Connection, e.message
      end

      private

      def configure_connection(headers:, timeout:, params:)
        raise Noldor::Exceptions::InvalidRequest, 'Please provide a valid api key' if Noldor.credentials.api_key.empty?

        default_headers = {
          'Authorization': "Bearer #{Noldor.credentials.api_key}",
          'Content-Type': 'application/json'
        }

        Faraday.new(url: Noldor.credentials.api_base) do |conn|
          conn.use FaradayMiddleware::FollowRedirects, limit: 3
          conn.headers = default_headers.merge(headers)
          conn.params = params
          conn.options.timeout = timeout
          conn.options.open_timeout = timeout
          conn.request :json
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
