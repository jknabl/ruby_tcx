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

    def namespace_mapping_for(prefix)
      { 'ns' => namespace_for(prefix) }
    end

    private

    def namespace_prefix_mapping
      {
        'ns1' => 'xmlns',
        'ns2' => 'xmlns:ns2',
        'ns3' => 'xmlns:ns3',
        'ns5' => 'xmlns:ns5',
        'xsi' => 'xmlns:xsi'
      }
    end

    def namespace_for(prefix)
      document.namespaces[namespace_prefix_mapping[prefix]]
    end

    def parse_activities
      document.xpath('//ns:Activity', namespace_mapping_for('ns1')).map { |element| parse_activity(element) }
    end

    def parse_activity(activity_element)
      RubyTcx::ActivityParser.new(element: activity_element, parser: self).parse
    end

    def parse_lap(lap_element)
      RubyTcx::LapParser.new(element: lap_element, parser: self).parse
    end

    def parse_track_point(track_point_element)
      RubyTcx::TrackPointParser.new(element: track_point_element, parser: self).parse
    end

    def nokogiri_document_from(path:)
      file = File.open(path)
      doc = Nokogiri::XML(file)
      file.close

      doc
    end
  end
end
