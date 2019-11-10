require 'test_helper'
require 'nokogiri'

class LapParserTest < Minitest::Test
  attr_reader :lap_element, :lap, :parser

  def setup
    tcx_file = RubyTcx::TcxFile.new(file_name: RubyTcx::TestConfig::DEFAULT_FIXTURE_PATH)
    nokogiri_doc = tcx_file.parser.document
    @lap_element = nokogiri_doc.xpath('//xmlns:Lap')[1]
    @parser = RubyTcx::LapParser.new(element: lap_element, parser: tcx_file.parser)
    @lap = parser.parse
  end

  def test_parses_start_time
    time = lap.start_time

    assert_equal 20, time.day
    assert_equal 10, time.month
    assert_equal 2019, time.year
    assert_equal 13, time.hour
    assert_equal 9, time.min
    assert_equal 25, time.sec
    assert_equal 'UTC', time.zone
  end

  def test_parses_total_time_seconds
    assert_equal 331.0, lap.total_time_seconds
  end

  def test_parses_distance_meters
    assert_equal 1000.0, lap.distance_meters
  end

  def test_parses_maximum_speed
    assert_equal 3.3589999675750737, lap.maximum_speed
  end

  def test_parses_calories
    assert_equal 68, lap.calories
  end

  def test_parses_average_heart_rate_bpm
    assert_equal 152, lap.average_heart_rate_bpm
  end

  def test_parses_maximum_heart_rate_bpm
    assert_equal 156, lap.maximum_heart_rate_bpm
  end

  def test_parses_intensity
    assert_equal 'Active', lap.intensity
  end

  def test_parses_trigger_method
    assert_equal 'Manual', lap.trigger_method
  end

  def test_parses_average_speed
    assert_equal 3.0169999599456787, lap.average_speed
  end

  def test_parses_average_run_cadence
    assert_equal 94, lap.average_run_cadence
  end

  def test_parses_maximum_run_cadence
    assert_equal 98, lap.maximum_run_cadence
  end

  def test_parses_track_points
    assert_kind_of Array, lap.track_points
    assert_equal 47, lap.track_points.count

    lap.track_points.each { |track_point| assert_kind_of RubyTcx::TrackPoint, track_point }
  end
end