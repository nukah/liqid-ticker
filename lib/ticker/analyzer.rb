require 'forwardable'

module Ticker
  class Analyzer
    extend Forwardable
    attr_reader :retriever

    def_delegators :@retriever, :stock_data

    def initialize(retriever)
      @retriever = retriever
    end

    def history
      @history ||= data.sort_by(&:day)
    end

    def top_drawdowns
      @top_drawdowns ||= data.select(&:negative?).sort.first(3)
    end

    def highest_drawdown
      top_drawdowns.first
    end

    def return
      @return ||= Return.new(history.first, history.last)
    end

    def empty?
      data.empty?
    end

    private

    def data
      @data ||= stock_data.each.map do |date, start, close|
        Result.new(date, start, close)
      end
    end
  end
end
