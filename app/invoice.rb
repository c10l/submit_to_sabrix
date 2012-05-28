class Invoice
  require 'nokogiri'

  attr_reader :xml
  
  def initialize(xml)
    @xml = xml
  end

  def is_audited?
    @audit ||= lambda {
      doc = Nokogiri::XML(@xml)
      audit = doc.at('IS_AUDITED').text if doc.at('IS_AUDITED').respond_to?(:text)
      @audit = 'false' != audit
    }.call
  end

  def set_audit(audit = false)
    return @xml if @xml.is_audited?.to_s == audit
    doc = Nokogiri::XML(@xml)
    node = Nokogiri::XML::Node.new 'IS_AUDITED', doc
    node.content = audit.to_s
    doc.at('EXTERNAL_COMPANY_ID').add_next_sibling(node)
    @xml = doc.to_xml
  end
end