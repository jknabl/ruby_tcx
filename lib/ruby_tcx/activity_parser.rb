require 'nokogiri'
require 'time'

module RubyTcx
  class ActivityParser
    attr_reader :activity_element, :document_parser

    def initialize(element:, parser:)
      @activity_element = element
      @document_parser = parser
    end

    def parse
      RubyTcx::Activity.new(
        id: parse_id,
        sport: parse_sport,
        laps: parse_laps
      )
    end

    private

    def parse_id
      Time.parse(activity_element.at_xpath('ns:Id', namespace_mapping_for('TrainingCenterDatabase')))
    end

    def parse_sport
      activity_element['Sport']
    end

    def parse_lap(lap_element)
      RubyTcx::LapParser.new(element: lap_element, parser: document_parser).parse
    end

    def parse_laps
      activity_element.xpath('ns:Lap', namespace_mapping_for('TrainingCenterDatabase')).map { |element| parse_lap(element) }
    end

    def namespace_mapping_for(prefix)
      document_parser.namespace_mapping_for(prefix)
    end
  end
end