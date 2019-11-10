require 'nokogiri'

module RubyTcx
  class Parser < BaseParser
    attr_reader :document

    def initialize(tcx_file)
      super(tcx_file)
      @document = nokogiri_document_from(path: tcx_file.file_name)
    end

    def parse
      parse_activity(document)
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

    def parse_activity(document)
      activity_node = document.at_xpath('//ns:Activity', namespace_mapping_for('ns1'))
      id_node = activity_node.at_xpath('//ns:Id', namespace_mapping_for('ns1'))
      id = Time.new(id_node.inner_html)
      sport = activity_node['Sport']

      lap_nodes = activity_node.xpath('//ns:Lap', namespace_mapping_for('ns1'))
      laps = lap_nodes.map { |node| parse_lap(node) }

      RubyTcx::Activity.new(
        id: id,
        sport: sport,
        laps: laps
      )
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
