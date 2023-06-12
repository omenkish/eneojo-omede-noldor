# frozen_string_literal: true

module Noldor
  module Exceptions
    autoload :Base, 'noldor/exceptions/base'
    autoload :ApiError, 'noldor/exceptions/api_error'
    autoload :Connection, 'noldor/exceptions/connection'
    autoload :InvalidRequest, 'noldor/exceptions/invalid_request'
    autoload :InvalidResponse, 'noldor/exceptions/invalid_response'
  end
end
