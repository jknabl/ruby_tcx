require 'nokogiri'
require 'time'

module RubyTcx
  class TrackPointParser
    attr_reader :track_point_element, :parser

    def initialize(element:, parser:)
      @track_point_element = element
      @parser = parser
    end

    def parse
      RubyTcx::TrackPoint.new(
        time: parse_time,
        latitude: parse_latitude,
        longitude: parse_longitude,
        altitude_meters: parse_altitude_meters,
        distance_meters: parse_distance_meters,
        heart_rate_bpm: parse_hr_bpm,
        speed: parse_speed,
        run_cadence: parse_cadence
      )
    end

    private

    def parse_time
      Time.parse(parser.find('ns:Time', track_point_element).inner_html)
    end

    def parse_latitude
      parser.find('.//ns:LatitudeDegrees', track_point_element).inner_html&.to_f
    end

    def parse_longitude
      parser.find('.//ns:LongitudeDegrees', track_point_element).inner_html&.to_f
    end

    def parse_altitude_meters
      parser.find('ns:AltitudeMeters', track_point_element).inner_html&.to_i
    end

    def parse_distance_meters
      parser.find('ns:DistanceMeters', track_point_element).inner_html&.to_f
    end

    def parse_hr_bpm
      parser.find('.//ns:HeartRateBpm/ns:Value', track_point_element).inner_html&.to_i
    end

    def parse_speed
      parser.find('.//ns:Speed', track_point_element, 'ActivityExtension').inner_html&.to_f
    end

    def parse_cadence
      parser.find('.//ns:RunCadence', track_point_element, 'ActivityExtension').inner_html&.to_i
    end
  end
end