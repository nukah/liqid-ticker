module Ticker
  class Analyzer
    attr_reader :stream

    def initialize(stream)
      @stream = stream
    end

    def drawdowns
      @drawdowns ||=
    end

    private

    def change(start_price, close_price)
      ((close_price.to_f - start_price.to_f) / start_price.to_f).round(2)
    end
  end
end
