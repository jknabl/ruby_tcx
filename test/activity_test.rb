require 'test_helper'

class ActivityTest < Minitest::Test
  def test_id_is_required
    assert_raises ArgumentError do
      RubyTcx::Activity.new(laps: [], sport: 'Running')
    end
  end

  def test_laps_is_required
    assert_raises ArgumentError do
      RubyTcx::Activity.new(id: 'blah', sport: 'Running')
    end
  end

  def test_sport_is_required
    assert_raises ArgumentError do
      RubyTcx::Activity.new(id: 'blah', laps: [])
    end
  end
end