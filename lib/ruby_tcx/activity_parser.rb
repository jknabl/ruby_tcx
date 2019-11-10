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
      Time.parse(document_parser.find('ns:Id', activity_element))
    end

    def parse_sport
      activity_element['Sport']
    end

    def parse_lap(lap_element)
      RubyTcx::LapParser.new(element: lap_element, parser: document_parser).parse
    end

    def parse_laps
      document_parser.find_all('ns:Lap', activity_element).map { |element| parse_lap(element) }
    end
  end
end