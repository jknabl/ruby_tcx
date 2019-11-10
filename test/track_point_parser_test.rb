require 'test_helper'
require 'nokogiri'
require 'time'

class TrackPointParserTest < Minitest::Test
  attr_reader :track_point_element, :track_point, :parser

  def setup
    tcx_file = RubyTcx::TcxFile.new(file_name: RubyTcx::TestConfig::DEFAULT_FIXTURE_PATH)
    nokogiri_doc = tcx_file.parser.document
    @track_point_element = nokogiri_doc.xpath('//xmlns:Trackpoint')[1]
    @parser = RubyTcx::TrackPointParser.new(element: track_point_element, parser: tcx_file.parser)
    @track_point = parser.parse
  end

  def test_parse_gets_time
    time = track_point.time

    assert_equal 20, time.day
    assert_equal 10, time.month
    assert_equal 2019, time.year
    assert_equal 13, time.hour
    assert_equal 3, time.min
    assert_equal 41, time.sec
    assert_equal 'UTC', time.zone
  end

  def test_parse_gets_latitude_degrees
    assert_equal 43.651060592383146, track_point.latitude
  end

  def test_parse_gets_longitude_degrees
    assert_equal -79.38660118728876, track_point.longitude
  end

  def test_parse_gets_altitude_meters
    assert_equal 88.0, track_point.altitude_meters
  end

  def test_parse_gets_distance_meters
    assert_equal 3.9100000858306885, track_point.distance_meters
  end

  def test_parse_gets_heart_rate_bpm
    assert_equal 113, track_point.heart_rate_bpm
  end

  def test_parse_gets_speed
    assert_equal 2.13700008392334, track_point.speed
  end

  def test_parse_gets_cadence
    assert_equal 89, track_point.run_cadence
  end
end