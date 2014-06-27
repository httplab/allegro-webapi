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

      def do_get_my_sell_items(page_number: 0)
        do_get_my_items(:sell, page_number: page_number)
      end

      def do_get_my_future_items(page_number: 0)
        do_get_my_items(:future, page_number: page_number)
      end

      def do_get_my_sold_items(page_number: 0)
        do_get_my_items(:sold, page_number: page_number)
      end

      def do_get_my_not_sold_items(page_number: 0)
        do_get_my_items(:not_sold, page_number: page_number)
      end

      def do_get_items_info(items_id_array)
        msg = {
          session_handle: client.session_handle,
          items_id_array: { item: items_id_array }
        }

        allegro_get(:do_get_items_info, msg)
      end

      def do_get_transactions_ids(items_id_array, user_role: :seller)
        msg = {
          session_handle: client.session_handle,
          items_id_array: { item: items_id_array },
          user_role: user_role
        }

        allegro_get(:do_get_transactions_i_ds, msg)
      end

      def do_get_post_buy_forms_data_for_sellers(id_array)
        msg = {
          session_id: client.session_handle,
          transactions_ids_array: { item: id_array }
        }

        allegro_get(:do_get_post_buy_forms_data_for_sellers, msg)
      end

      def do_new_auction_ext(*fields)
        msg = {
          session_handle: client.session_handle,
          fields: fields
        }

        client.call(:do_new_auction_ext, message: msg)
      end

      def do_finish_items(id_array)
        msg = {
          session_handle: client.session_handle,
          finish_items_list: { item: id_array.map { |id| { finish_item_id: id } } }
        }

        allegro_get(:do_finish_items, msg)
      end

      def do_get_my_bid_items(id_array)
        msg = {
          session_id: client.session_handle,
          item_ids: { item: id_array }
        }

        allegro_get(:do_get_my_bid_items, msg)
      end

      def do_change_price_item(item_id, options)
        msg = options.reverse_merge({
          session_handle: client.session_handle,
          item_id: item_id
        })

        allegro_get(:do_change_price_item, msg)
      end

      def do_add_desc_to_items(id_array, description)
        msg = {
          session_handle: client.session_handle,
          items_id_array: { item: id_array },
          it_description: description
        }

        allegro_get(:do_add_desc_to_items, msg)
      end

      def do_change_item_fields(item_id, options)
        msg = options.reverse_merge({
          session_id: client.session_handle,
          item_id: item_id
        })

        allegro_get(:do_change_item_fields, msg)
      end

      def do_sell_some_again(id_array, options)
        msg = options.reverse_merge({
          session_handle: client.session_handle,
          sell_items_array: { item: id_array }
        })

        start_time = msg[:sell_starting_time]
        msg[:sell_starting_time] = start_time.to_i if start_time

        allegro_get(:do_sell_some_again, msg)
      end

      def do_verify_item(local_id)
        msg = {
          session_handle: client.session_handle,
          local_id: local_id
        }

        allegro_get(:do_verify_item, msg)
      end

      private

      def do_get_my_items(items_type, page_number: 0)
        msg = {
          session_id: client.session_handle,
          page_number: page_number
        }

        method_name = "do_get_my_#{items_type}_items".to_sym
        allegro_get(method_name, msg)
      end

      def allegro_get(method_name, msg)
        r = client.call(method_name.to_sym, message: msg)
        r.body["#{method_name}_response".to_sym]
      end
    end
  end
end
