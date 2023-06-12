module Noldor
  module Resources
    module Base
      def retrieve(params:, path:)
        raise ArgumentError, 'Options param must be a hash. example resource.all({limit: 10})' unless params.is_a? Hash

        formatted_path = set_params(params: params, path: path)

        Noldor::Http::Request.instance.send_http(method: 'GET', path: formatted_path)
      end

      private

      def set_params(params:, path:)
        return path if params.empty?

        "#{path}?#{URI.encode_www_form(params)}"
      end
    end
  end
end
