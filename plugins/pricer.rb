require 'nokogiri'
require 'open-uri'

class Pricer < CampfireBot::Plugin
  STOCK_SYMBOL = /[A-Z]{2,6}/

  on_message %r/gold/i, :gold_price
  on_message STOCK_SYMBOL, :stock_price

  def initialize
    @log = Logging.logger["CampfireBot::Plugin::Pricer"]
  end

  def gold_price(m)
    url = 'http://www.kitco.com/market/'
    doc = Nokogiri::HTML(open url)
    tr = doc.css('tr[bgcolor="#F3F3E4"][align="center"]')[4]
    p = tr.css 'td p'
    price = "GOLD - bid: #{p[3].content} ask: #{p[4].content} - low: #{p[7].content} hi: #{p[8].content} - #{p[1].content} #{p[2].content} #{url}"
    m.speak price
  end

  def stock_price(m)
    base_url = 'https://www.google.com/finance?authuser=0&hl=en&q='
    m[:message].scan(STOCK_SYMBOL) do |symbol|
      url = base_url + symbol
      doc = Nokogiri::HTML(open url)
      next unless pr = doc.at_css('span.pr span')
      price = pr.content
      ch = doc.css 'span.ch span'
      change = "(#{ch[0].content} / #{ch[1].content.chop[1..-1]})"
      datetime = doc.at_css('.mdata-dis').parent.children.first.text
      response = "#{symbol} - #{price} #{change} - #{datetime} #{url}"
      m.speak response
    end
  end
end