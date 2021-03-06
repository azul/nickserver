require 'nickserver/adapters'
silence_warnings do
  require 'celluloid/io'
end
require 'http'

module Nickserver::Adapters
  class CelluloidHttp
    include Celluloid::IO

    def get(url, options = {})
      response = HTTP.get url,
        params: options[:query],
        ssl_context: ctx,
        ssl_socket_class: Celluloid::IO::SSLSocket
      return response.code, response.to_s
    end

    def ctx
      OpenSSL::SSL::SSLContext.new.tap do |ctx|
        ctx.ca_file = Nickserver::Config.hkp_ca_file
      end
    end
  end
end
