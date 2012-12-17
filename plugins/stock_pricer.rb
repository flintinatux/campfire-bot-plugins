require 'nokogiri'
require 'open-uri'

class StockPricer < CampfireBot::Plugin
  attr_accessor :page, :url

  on_command 'stock', :stock_price

  def initialize
    @log = Logging.logger["CampfireBot::Plugin::StockPricer"]
  end

  def stock_price(m)
    m[:message].scan(stock_symbol) do |symbol|
      load_stock_data_for symbol
      next unless price_available?
      m.speak response
    end
  end

  private

    def base_stock_url
      'https://www.google.com/finance?authuser=0&hl=en&q='
    end

    def change
      ch = page.css 'span.ch span'
      change = "(#{ch[0].content} / #{ch[1].content.chop[1..-1]})"
    end

    def datetime
      page.at_css('.mdata-dis').parent.children.first.text
    end

    def load_stock_data_for(symbol)
      url = base_stock_url + symbol
      page = Nokogiri::HTML(open url)
    end

    def price
      return nil unless price_span = page.at_css('span.pr span')
      price_span.content
    end

    def price_available?
      ! price.nil?
    end

    def response
      "#{symbol} - #{price} #{change} - #{datetime} #{url}"
    end

    def stock_symbol
      /[A-Z]{2,6}/
    end
end