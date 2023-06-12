# frozen_string_literal: true

module Noldor
  module Resources
    class Book
      RESOURCE_NAME = 'book'

      extend Noldor::Resources::Base

      class << self
        def all(options: {})
          response = retrieve(params: options, path: RESOURCE_NAME)

          new(headers: response[:headers], data: response[:data], status: response[:status])
        end

        def find(id:, options: {})
          if id.nil? || id.empty?
            if Noldor.credentials.exception_enabled
              raise Noldor::Exceptions::InvalidRequest, 'ID is required for this action'
            end

            return false
          end

          path = "#{RESOURCE_NAME}/#{id}"
          response = retrieve(params: options, path: path)

          new(headers: response[:headers], data: response[:data], status: response[:status])
        end

        def book_chapters(book_id:, options: {})
          if book_id.nil? || book_id.empty?
            if Noldor.credentials.exception_enabled
              raise Noldor::Exceptions::InvalidRequest, 'ID is required for this action'
            end

            return false
          end

          path = "#{RESOURCE_NAME}/#{book_id}/chapter"
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
