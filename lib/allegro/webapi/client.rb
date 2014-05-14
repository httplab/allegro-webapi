module Allegro
  module WebApi
    class Client
      END_POINT = 'https://webapi.allegro.pl/service.php?wsdl'

      attr_accessor :user_login, :webapi_key, :country_code
      attr_reader :client, :password, :session_handle, :local_version

      def initialize
        yield self
      end

      def password=(password)
        hash = Digest::SHA256.new.digest(password)
        @password = Base64.encode64(hash)
      end

      def do_query_sys_status
        start_client
        message = { sysvar: 1, country_id: country_code, webapi_key: webapi_key }
        client.call(:do_query_sys_status, message: message).body[:do_query_sys_status_response]
      end

      def login
        start_client

        @local_version = do_query_sys_status[:ver_key]

        message = {
          user_login: user_login,
          user_hash_password: password,
          country_code: country_code,
          webapi_key: webapi_key,
          local_version: local_version

        }
        response = client.call(:do_login_enc, message: message)

        set_session_handle(response)
        self
      end

      def call(operation_name, message = {})
        # TODO: Непонятно, в некоторых случаях требуется country_code, в некоторых country_id
        # message.merge!({ country_id: country_code, local_version: local_version, webapi_key: webapi_key})
        message.merge!({ local_version: local_version, webapi_key: webapi_key})
        client.call(operation_name, message: message)
      end

      private

      def set_session_handle(login_response)
        @session_handle = login_response.body[:do_login_enc_response][:session_handle_part]
      end

      def start_client
        @client ||= Savon.client do
          ssl_verify_mode :none
          wsdl END_POINT
          log true
          log_level :debug
          pretty_print_xml true
          strip_namespaces true
        end
      end
    end
  end
end
