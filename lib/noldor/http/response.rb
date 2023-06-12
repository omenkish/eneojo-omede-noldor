# frozen_string_literal: true

require 'json'

module Noldor
  module Http
    # Creates an instance of the given resource class
    #
    # @param [String, #read] contents the contents to reverse
    # @return [Resource] the resource object
    class Response
      using ControlledPatch

      attr_reader :status, :data, :headers

      def initialize(klass:, response:)
        @response = response
        @klass = klass
      end

      # Creates an instance of the given resource class
      #
      # @return [Resource] the resource object
      def response
        @headers = @response.headers
        @status = @response.status
        @data = data_to_json(@response.body)

        @klass.new(headers: @headers, data: @data, status: @status)
      end

      def success?
        @response.success?
      end

      def error?
        !success?
      end

      private

      def data_to_json(data)
        json = JSON.parse(data)

        if json['docs'].is_a? Hash
          json.deep_transform_keys!(&:underscore)
        elsif json['docs'].is_a? Array
          json['docs'] = json['docs'].map { |item| item.deep_transform_keys!(&:underscore) }
        end

        JSON.parse(json.to_json, object_class: OpenStruct)
      rescue JSON::ParserError
        raise Noldor::Exceptions::InvalidResponse, 'Invalid response object'
      end
    end
  end
end
