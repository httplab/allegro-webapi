module Allegro
  module WebApi
    class Category
      attr_reader :client

      def initialize(client = nil)
        @client = client || Allegro::WebApi.client
      end

      def do_get_cats_data
        client.call(:do_get_cats_data, { country_id: client.country_code }).body[:do_get_cats_data_response]
      end
    end
  end
end
