require 'nokogiri'
require 'open-uri'

class GoldPricer < CampfireBot::Plugin
  attr_accessor :page

  on_message %r/GOLD/, :gold_price

  def initialize
    @log = Logging.logger["CampfireBot::Plugin::GoldPricer"]
  end

  def gold_price(m)
    page = Nokogiri::HTML(open gold_url)
    m.speak response
  end

  private

    def gold_url
      'http://www.kitco.com/market/'
    end

    def parse_gold_data
      page.css('tr[bgcolor="#F3F3E4"][align="center"]')[4].css 'td p'
    end

    def response
      data = parse_gold_data
      bid  = data[3].content
      ask  = data[4].content
      low  = data[7].content
      hi   = data[8].content
      date = data[1].content
      time = data[2].content
      "GOLD - bid: #{bid} ask: #{ask} - low: #{low} hi: #{hi} - #{date} #{time} #{gold_url}"
    end
end