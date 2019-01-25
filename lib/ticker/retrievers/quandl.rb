require 'faraday'
require 'faraday_middleware'
require 'excon'
require 'date'

module Ticker
  module Retrievers
    class Quandl
      URL = 'https://www.quandl.com/api/v3/datasets/WIKI'.freeze

      attr_reader :ticker, :options

      def initialize(ticker, options = {})
        @ticker = ticker
        @options = options
      end

      def stock_data
        raise StandardError, 'Ticker is not set!' if ticker.nil?
        raise StandardError, 'API_KEY is not set!' if api_key.nil?
        raise StandardError, 'API returned error' unless request.success?

        return enum_for(:stock_data) unless block_given?

        data.each { |day| yield(day[0], day[1], day[4]) }
      end

      private

      def data
        @data ||= request.body['dataset_data']['data']
      end

      def start_date
        Date.parse(options[:start_date].to_s)
      rescue ArgumentError
        raise StandardError, 'You should provide start date and in correct format (YYYY-MM-DD)'
      end

      def end_date
        return Date.today unless options.key?(:end_date)

        Date.parse(options[:end_date].to_s)
      rescue ArgumentError
        raise StandardError, 'You should provide end date in correct format(YYYY-MM-DD)'
      end

      def request
        @request ||= connection.get("#{ticker.to_s.upcase}/data.json", api_key: api_key,
                                                                       start_date: start_date,
                                                                       end_date: end_date)
      end

      def api_key
        ENV['API_KEY']
      end

      def connection
        @connection ||= Faraday.new(url: URL) do |c|
          c.request :json
          c.response :json, content_type: /\bjson$/
          c.adapter :excon
        end
      end
    end
  end
end
