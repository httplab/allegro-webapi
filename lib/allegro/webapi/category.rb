module Allegro
  module WebApi
    class Category
      attr_reader :client

      def initialize(client = nil)
        @client = client || Allegro::WebApi.client
      end

      def do_get_cats_data
        mgs = {
          country_id: client.country_code,
          local_version: client.local_version,
          webapi_key: client.webapi_key
        }

        client.call(:do_get_cats_data, message: mgs).body[:do_get_cats_data_response]
      end
    end
  end
end
