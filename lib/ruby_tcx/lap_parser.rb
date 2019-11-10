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
      document_parser.find('ns:TotalTimeSeconds', lap_element).inner_html.to_f
    end

    def parse_distance_meters
      document_parser.find('ns:DistanceMeters', lap_element).inner_html.to_f
    end

    def parse_maximum_speed
      document_parser.find('ns:MaximumSpeed', lap_element)&.inner_html.to_f
    end

    def parse_calories
      document_parser.find('ns:Calories', lap_element).inner_html.to_i
    end

    def parse_average_heart_rate_bpm
      document_parser.find('ns:AverageHeartRateBpm/ns:Value', lap_element)&.inner_html.to_i
    end

    def parse_maximum_heart_rate_bpm
      document_parser.find('ns:MaximumHeartRateBpm/ns:Value', lap_element)&.inner_html.to_i
    end

    def parse_intensity
      document_parser.find('ns:Intensity', lap_element).inner_html
    end

    def parse_trigger_method
      document_parser.find('ns:TriggerMethod', lap_element).inner_html
    end

    def parse_average_speed
      document_parser.find('.//ns:AvgSpeed', lap_element, 'ActivityExtension')&.inner_html&.to_f
    end

    def parse_average_run_cadence
      document_parser.find('.//ns:AvgRunCadence', lap_element, 'ActivityExtension')&.inner_html&.to_i
    end

    def parse_maximum_run_cadence
      document_parser.find('.//ns:MaxRunCadence', lap_element, 'ActivityExtension')&.inner_html&.to_i
    end

    def parse_track_point(track_point_element)
      RubyTcx::TrackPointParser.new(element: track_point_element, parser: document_parser).parse
    end

    def parse_track_points
      document_parser.find_all('.//ns:Trackpoint', lap_element).map do |node|
        parse_track_point(node)
      end
    end
  end
end