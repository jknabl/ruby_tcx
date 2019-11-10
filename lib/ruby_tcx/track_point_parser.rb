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
      Time.parse(track_point_element.at_xpath('ns:Time', parser.namespace_mapping_for('ns1')).inner_html)
    end

    def parse_latitude
      track_point_element.at_xpath('.//ns:LatitudeDegrees', parser.namespace_mapping_for('ns1')).inner_html&.to_f
    end

    def parse_longitude
      track_point_element.at_xpath('.//ns:LongitudeDegrees', parser.namespace_mapping_for('ns1')).inner_html&.to_f
    end

    def parse_altitude_meters
      track_point_element.at_xpath('ns:AltitudeMeters', parser.namespace_mapping_for('ns1')).inner_html&.to_i
    end

    def parse_distance_meters
      track_point_element.at_xpath('ns:DistanceMeters', parser.namespace_mapping_for('ns1')).inner_html&.to_f
    end

    def parse_hr_bpm
      track_point_element.at_xpath('.//ns:HeartRateBpm/ns:Value', parser.namespace_mapping_for('ns1')).inner_html&.to_i
    end

    def parse_speed
      track_point_element.at_xpath('.//ns:Speed', parser.namespace_mapping_for('ns3')).inner_html&.to_f
    end

    def parse_cadence
      track_point_element.at_xpath('.//ns:RunCadence', parser.namespace_mapping_for('ns3')).inner_html&.to_i
    end
  end
end