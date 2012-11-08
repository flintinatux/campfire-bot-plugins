require 'nokogiri'
require 'open-uri'

class Pricer < CampfireBot::Plugin
  on_message %r[(price of gold|gold price)], :gold_price

  def initialize
    @log = Logging.logger["CampfireBot::Plugin::Pricer"]
  end

  def gold_price(m)
    url = 'http://www.kitco.com/market/'
    doc = Nokogiri::HTML(open(url))
    tr = doc.css('tr[bgcolor="#F3F3E4"][align="center"]')[4]
    p = tr.css 'td p'
    price = "GOLD - bid: #{p[3].content} ask: #{p[4].content} low: #{p[7].content} hi: #{p[8].content} - #{p[1].content} #{p[2].content} src: #{url}"
    m.speak price
  end
end