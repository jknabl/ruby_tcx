require 'nokogiri'
require 'time'

module RubyTcx
  class LapParser
    attr_reader :lap_element, :document_parser

    def initialize(element:, parser:)
      @lap_element = element
      @document_parser = parser
    end

    def parse
      RubyTcx::Lap.new(
        start_time: parse_start_time,
        total_time_seconds: parse_total_time_seconds,
        distance_meters: parse_distance_meters,
        maximum_speed: parse_maximum_speed,
        calories: parse_calories,
        average_heart_rate_bpm: parse_average_heart_rate_bpm,
        maximum_heart_rate_bpm: parse_maximum_heart_rate_bpm,
        intensity: parse_intensity,
        trigger_method: parse_trigger_method,
        track_points: parse_track_points,
        average_speed: parse_average_speed,
        average_run_cadence: parse_average_run_cadence,
        maximum_run_cadence: parse_maximum_run_cadence
      )
    end

    private

    def parse_start_time
      Time.parse(lap_element['StartTime'])
    end

    def parse_total_time_seconds
      lap_element.at_xpath('ns:TotalTimeSeconds', namespace_mapping_for('ns1')).inner_html.to_f
    end

    def parse_distance_meters
      lap_element.at_xpath('ns:DistanceMeters', namespace_mapping_for('ns1')).inner_html.to_f
    end

    def parse_maximum_speed
      lap_element.at_xpath('ns:MaximumSpeed', namespace_mapping_for('ns1')).inner_html.to_f
    end

    def parse_calories
      lap_element.at_xpath('ns:Calories', namespace_mapping_for('ns1')).inner_html.to_i
    end

    def parse_average_heart_rate_bpm
      lap_element.at_xpath('ns:AverageHeartRateBpm/ns:Value', namespace_mapping_for('ns1')).inner_html.to_i
    end

    def parse_maximum_heart_rate_bpm
      lap_element.at_xpath('ns:MaximumHeartRateBpm/ns:Value', namespace_mapping_for('ns1')).inner_html.to_i
    end

    def parse_intensity
      lap_element.at_xpath('ns:Intensity', namespace_mapping_for('ns1')).inner_html
    end

    def parse_trigger_method
      lap_element.at_xpath('ns:TriggerMethod', namespace_mapping_for('ns1')).inner_html
    end

    def parse_average_speed
      lap_element.at_xpath('.//ns:AvgSpeed', namespace_mapping_for('ns3')).inner_html&.to_f
    end

    def parse_average_run_cadence
      lap_element.at_xpath('.//ns:AvgRunCadence', namespace_mapping_for('ns3')).inner_html&.to_i
    end

    def parse_maximum_run_cadence
      lap_element.at_xpath('.//ns:MaxRunCadence', namespace_mapping_for('ns3')).inner_html&.to_i
    end

    def parse_track_point(track_point_element)
      RubyTcx::TrackPointParser.new(element: track_point_element, parser: document_parser).parse
    end

    def parse_track_points
      lap_element.xpath('.//ns:Trackpoint', namespace_mapping_for('ns1')).map do |node|
        parse_track_point(node)
      end
    end

    def namespace_mapping_for(prefix)
      document_parser.namespace_mapping_for(prefix)
    end
  end
end