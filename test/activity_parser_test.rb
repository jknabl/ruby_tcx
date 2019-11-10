require 'test_helper'

class ActivityParserTest < Minitest::Test
  attr_reader :activity_element, :activity, :parser

  def setup
    tcx_file = RubyTcx::TcxFile.new(file_name: RubyTcx::TestConfig::DEFAULT_FIXTURE_PATH)
    nokogiri_doc = tcx_file.parser.document
    @activity_element = nokogiri_doc.xpath('//xmlns:Activity').first
    @parser = RubyTcx::ActivityParser.new(element: activity_element, parser: tcx_file.parser)
    @activity = parser.parse
  end

  def test_parses_id
    time = activity.id

    assert_equal 20, time.day
    assert_equal 10, time.month
    assert_equal 2019, time.year
    assert_equal 13, time.hour
    assert_equal 3, time.min
    assert_equal 40, time.sec
    assert_equal 'UTC', time.zone
  end

  def test_parses_sport
    assert_equal 'Running', activity.sport
  end

  def test_parses_laps
    assert_kind_of Array, activity.laps
    assert_equal 2, activity.laps.count

    activity.laps.each { |lap| assert_kind_of RubyTcx::Lap, lap }
  end
end