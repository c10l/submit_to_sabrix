class Sabrix
  require 'net/http'
  require 'uri'

  attr_reader :uri, :url

  def self.parse_url(url)
    xml_url = url
    xml_url = xml_url.match(/^http\:\/\/.+\/sabrix/).to_s + '/xmlinvoice' unless xml_url.end_with? 'xmlinvoice'
    URI.parse(xml_url)
  end

  def initialize(url)
    @uri = Sabrix::parse_url(url)
    @url = @uri.to_s
  end

  def submit(indata)
    params = { 'instring' => indata, 'XMLINPUT' => 'Calculate Tax' }
    Net::HTTP.post_form(@uri, params)
  end
end