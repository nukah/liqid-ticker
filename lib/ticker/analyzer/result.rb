require 'date'

module Ticker
  class Analyzer::Result
    attr_reader :date, :start_price, :close_price

    def initialize(date, start, close)
      @date = date
      @start_price = start.to_f
      @close_price = close.to_f
    end

    def negative?
      diff < 0
    end

    def <=>(other)
      diff <=> other.diff
    end

    def day
      Date.parse(date)
    end

    def to_drawdown
      "#{diff}% (#{start_price} on #{day} -> #{close_price} on #{day})"
    end

    def to_s
      "#{day}: Closed at #{close_price} (#{start_price} ~ #{close_price})"
    end

    def inspect
      to_s
    end

    def diff
      @diff ||= (((close_price - start_price) / start_price) * 100).round(3)
    end
  end
end
