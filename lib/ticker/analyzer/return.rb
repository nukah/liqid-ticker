require 'date'

module Ticker
  class Analyzer::Return
    attr_reader :start_result, :end_result

    def initialize(start_result, end_result)
      @start_result = start_result
      @end_result = end_result
    end

    def to_s
      "Return: #{profit} [#{diff}%] (#{start_price} on #{start_date} -> #{end_price} on #{end_date})"
    end

    def inspect
      to_s
    end

    private

    def start_price
      start_result.start_price
    end

    def end_price
      end_result.close_price
    end

    def start_date
      start_result.day
    end

    def end_date
      end_result.day
    end

    def profit
      @profit ||= (end_price - start_price).round(3)
    end

    def diff
      @diff ||= ((profit / start_price) * 100).round(3)
    end
  end
end
