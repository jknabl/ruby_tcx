require 'test_helper'
require 'time'

class ParserTest < Minitest::Test
  attr_reader :tcx_file

  def setup
    @tcx_file = RubyTcx::TestConfig.load_fixture('stwm2019')
  end

  def test_tcx_file_is_required
    assert_raises ArgumentError do
      RubyTcx::Parser.new
    end
  end

  def test_parse_returns_array_of_activities
    parsed = RubyTcx::Parser.new(tcx_file).parse

    assert_kind_of Array, parsed
    assert_kind_of RubyTcx::Activity, parsed.first
  end

  def test_parses_file_with_multiple_activities
    file = RubyTcx::TestConfig.load_fixture('stwm2019-multiple')
    parsed = RubyTcx::Parser.new(file).parse

    first_expected_id = Time.parse('2019-10-20T13:03:40.000Z')
    second_expected_id = Time.parse('2019-10-20T17:03:40.000Z')

    refute_equal first_expected_id, second_expected_id
    assert_equal first_expected_id, parsed[0].id
    assert_equal second_expected_id, parsed[1].id
    assert 2, parsed.length
  end
end