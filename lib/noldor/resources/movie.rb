# frozen_string_literal: true

module Noldor
  module Resources
    class Movie
      RESOURCE = 'movie'
      extend Noldor::Resources::Base

      class << self
        def all(options: {})
          response = retrieve(params: options, path: RESOURCE)

          new(headers: response[:headers], data: response[:data], status: response[:status])
        end

        def find(options: {}, id:)
          if id.nil? || id.empty?
            if Noldor.credentials.exception_enabled
              raise Noldor::Exceptions::InvalidRequest, 'ID is required for this action'
            end

            return false
          end

          path = "#{RESOURCE}/#{id}"
          response = retrieve(params: options, path: path)

          new(headers: response[:headers], data: response[:data], status: response[:status])
        end

        def movie_quotes(options: {}, movie_id:)
          if movie_id.nil? || movie_id.empty?
            if Noldor.credentials.exception_enabled
              raise Noldor::Exceptions::InvalidRequest, 'ID is required for this action'
            end

            return false
          end

          path = "#{RESOURCE}/#{movie_id}/quote"
          response = retrieve(params: options, path: path)

          new(headers: response[:headers], data: response[:data], status: response[:status])
        end
      end

      attr_reader :data, :headers, :status

      def initialize(data: {}, headers: nil, status: nil)
        @data = data
        @headers = headers
        @status = status
      end
    end
  end
end
