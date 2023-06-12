# frozen_string_literal: true

require 'json'

module Noldor
  module Http
    # Creates an instance of the given resource class
    #
    # @param [klass, response]
    # @return [resource] the resource object
    class Response
      using ControlledPatch

      attr_reader :status, :data, :headers

      def initialize(response:, single_data:)
        @response = response
        @single_data = single_data
      end

      # Creates an instance of the given resource class
      #
      # @return [Resource] a hash of headers, data and status
      def response
        @headers = @response.headers
        @status = @response.status
        @data = data_to_json(@response.body)

        { headers: @headers, data: @data, status: @status }
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

        formatted_data = format_data(data: json)
        JSON.parse(formatted_data.to_json, object_class: OpenStruct)
      rescue JSON::ParserError
        raise Noldor::Exceptions::InvalidResponse, 'Invalid response object'
      end

      def format_data(data:)
        docs = data['docs']

        if @single_data
          docs.first
        else
          meta = {
            limit: data['limit'],
            offset: data['offset'],
            page: data['page'],
            pages: data['pages'],
            total: data['total']
          }

          { data: docs, meta: meta }
        end
      end
    end
  end
end
