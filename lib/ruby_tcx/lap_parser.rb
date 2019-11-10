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
      lap_element.at_xpath('ns:TotalTimeSeconds', default_namespace_mapping).inner_html.to_f
    end

    def parse_distance_meters
      lap_element.at_xpath('ns:DistanceMeters', default_namespace_mapping).inner_html.to_f
    end

    def parse_maximum_speed
      lap_element.at_xpath('ns:MaximumSpeed', default_namespace_mapping).inner_html.to_f
    end

    def parse_calories
      lap_element.at_xpath('ns:Calories', default_namespace_mapping).inner_html.to_i
    end

    def parse_average_heart_rate_bpm
      lap_element.at_xpath('ns:AverageHeartRateBpm/ns:Value', default_namespace_mapping).inner_html.to_i
    end

    def parse_maximum_heart_rate_bpm
      lap_element.at_xpath('ns:MaximumHeartRateBpm/ns:Value', default_namespace_mapping).inner_html.to_i
    end

    def parse_intensity
      lap_element.at_xpath('ns:Intensity', default_namespace_mapping).inner_html
    end

    def parse_trigger_method
      lap_element.at_xpath('ns:TriggerMethod', default_namespace_mapping).inner_html
    end

    def parse_average_speed
      lap_element.at_xpath('.//ns:AvgSpeed', activity_extension_mapping).inner_html&.to_f
    end

    def parse_average_run_cadence
      lap_element.at_xpath('.//ns:AvgRunCadence', activity_extension_mapping).inner_html&.to_i
    end

    def parse_maximum_run_cadence
      lap_element.at_xpath('.//ns:MaxRunCadence', activity_extension_mapping).inner_html&.to_i
    end

    def parse_track_point(track_point_element)
      RubyTcx::TrackPointParser.new(element: track_point_element, parser: document_parser).parse
    end

    def parse_track_points
      lap_element.xpath('.//ns:Trackpoint', default_namespace_mapping).map do |node|
        parse_track_point(node)
      end
    end

    def default_namespace_mapping
      document_parser.default_namespace_mapping
    end

    def activity_extension_mapping
      document_parser.activity_extension_mapping
    end
  end
end