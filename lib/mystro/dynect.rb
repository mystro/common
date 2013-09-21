module Mystro
  class Dynect
    def initialize(customer, username, password)
      @customer = customer
      @username = username
      @password = password
      @base = 'https://api2.dynect.net/REST/'
      @rest = RestClient::Resource.new(@base, :headers => {:content_type => 'application/json'}, :max_redirects => 10)
      login
    end

    def login

    end

    private

    def request(&block)
      body =
          begin
            response = block.call
            response.body
          rescue RestClient::Exception => e
            raise "error: #{e.response}"
          end
      parse(JSON.parse(body||{}))
    end

    def parse(response)
      case response['status']
        when 'success'
          response['data']
        else
          raise "error: #{response['status']}"
      end
    end
  end
end