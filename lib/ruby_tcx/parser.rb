require 'nokogiri'

module RubyTcx
  class Parser < BaseParser
    attr_reader :document

    def initialize(tcx_file)
      super(tcx_file)
      @document = nokogiri_document_from(path: tcx_file.file_name)
    end

    def parse
      parse_activities
    end

    def find(expression, element, namespace='TrainingCenterDatabase')
      element.at_xpath(expression, namespace_mapping_for(namespace))
    end

    def find_all(expression, element, namespace='TrainingCenterDatabase')
      element.xpath(expression, namespace_mapping_for(namespace))
    end

    private

    def parse_activities
      activity_elements = document.xpath('//ns:Activity', namespace_mapping_for('TrainingCenterDatabase'))
      activity_elements.map { |element| parse_activity(element) }
    end

    def parse_activity(activity_element)
      RubyTcx::ActivityParser.new(element: activity_element, parser: self).parse
    end

    def nokogiri_document_from(path:)
      file = File.open(path)
      doc = Nokogiri::XML(file)
      file.close

      doc
    end

    def schema_location_for(namespace)
      tcx_file.namespaces[namespace]
    end

    def namespace_mapping_for(namespace)
      { 'ns' => schema_location_for(namespace) }
    end
  end
end
