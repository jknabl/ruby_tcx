require 'test_helper'

class ActivityParserTest < Minitest::Test
  attr_reader :activity_element, :activity, :parser

  def setup
    tcx_file = RubyTcx::TestConfig.load_fixture('stwm2019-multiple')
    nokogiri_doc = tcx_file.parser.document
    @activity_element = nokogiri_doc.xpath('//xmlns:Activity')[1]
    @parser = RubyTcx::ActivityParser.new(element: activity_element, parser: tcx_file.parser)
    @activity = parser.parse
  end

  def test_parses_id
    time = activity.id

    assert_equal 20, time.day
    assert_equal 10, time.month
    assert_equal 2019, time.year
    assert_equal 17, time.hour
    assert_equal 3, time.min
    assert_equal 40, time.sec
    assert_equal 'UTC', time.zone
  end

  def test_parses_sport
    assert_equal 'RunningFaster', activity.sport
  end

  def test_parses_laps
    assert_kind_of Array, activity.laps
    assert_equal 2, activity.laps.count

    activity.laps.each { |lap| assert_kind_of RubyTcx::Lap, lap }
  end
end