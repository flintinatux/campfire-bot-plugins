require 'nokogiri'
require 'open-uri'

class GoldPricer < CampfireBot::Plugin
  attr_accessor :page, :data

  on_message %r/GOLD/, :gold_price

  def initialize
    @log = Logging.logger["CampfireBot::Plugin::GoldPricer"]
  end

  def gold_price(m)
    page = Nokogiri::HTML(open gold_url)
    data = load_gold_data
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
      "GOLD - bid: #{bid} ask: #{ask} - low: #{low} hi: #{hi} - #{date} #{time} #{gold_url}"
    end

    def bid
      data[3].content
    end

    def ask
      data[4].content
    end

    def low
      data[7].content
    end

    def hi
      data[8].content
    end

    def date
      data[1].content
    end

    def time
      data[2].content
    end
end