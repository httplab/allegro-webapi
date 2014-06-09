module Allegro
  module WebApi
    class Auction
      attr_reader :client

      def initialize(client = nil)
        @client = client || Allegro::WebApi.client
      end

      def do_get_sell_form_fields
        msg = {
          country_code: client.country_code,
          local_version: client.local_version,
          webapi_key: client.webapi_key
        }

        r = client.call(:do_get_sell_form_fields_ext, message: msg)
        r.body[:do_get_sell_form_fields_ext_response]
      end


      def do_check_new_auction_ext(*fields)
        # field = {
        #   fid: 1,
        #   fvalue_string: 'Новый лот'
        # }

        msg = {
          session_handle: client.session_handle,
          fields: fields
        }

        client.call(:do_check_new_auction_ext, message: msg)
      end

    def do_new_auction_ext(*fields)
      msg = {
        session_handle: client.session_handle,
        fields: fields
      }

      client.call(:do_new_auction_ext, message: msg)
    end
    end
  end
end
