# frozen_string_literal: true

module Noldor
  module Resources
    class Book
      RESOURCE = 'book'

      extend Noldor::Resources::Base

      class << self
        def all(options = {})
          retrieve(params: options, path: RESOURCE)
        end

        def find(options = {}, id:)
          if id.nil? || id.empty?
            if Noldor.credentials.exception_enabled
              raise Noldor::Exceptions::InvalidRequest, 'ID is required for this action'
            end

            return false
          end

          path = "#{RESOURCE}/#{id}"
          retrieve(params: options, path: path)
        end

        def book_chapters(options = {}, book_id:)
          if book_id.nil? || book_id.empty?
            if Noldor.credentials.exception_enabled
              raise Noldor::Exceptions::InvalidRequest, 'ID is required for this action'
            end

            return false
          end

          path = "#{RESOURCE}/#{book_id}/chapter"
          retrieve(params: options, path: path)
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
