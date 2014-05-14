module Allegro
  module WebApi
    class Auction
      attr_reader :client

      def initialize(client = nil)
        @client = client || Allegro::WebApi.client
      end

      #fields for form
      #Helpful for building forms
      def do_get_sell_form_fields
        client.call(:do_get_sell_form_fields_ext, { country_code: client.country_code })
      end

      #def do_check_new_auction_ext(*fields)
      #
      #end
      #
      #def do_new_auction_ext
      #
      #
      #end
    end
  end
end
