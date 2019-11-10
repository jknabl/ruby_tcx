require 'test_helper'
require 'time'

class ParserTest < Minitest::Test
  attr_reader :tcx_file, :ns_tcx_file

  def setup
    @tcx_file = RubyTcx::TestConfig.load_fixture('stwm2019')
    @ns_tcx_file = RubyTcx::TestConfig.load_fixture('namespace-test-file')
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

  def test_find_returns_first_element_under_tcdb_namespace_by_default
    parser = RubyTcx::Parser.new(ns_tcx_file)
    root_element = parser.document.root
    expected_id = '2019-10-20T13:03:40.000Z'

    value = parser.find('//ns:Activity/ns:Id', root_element).inner_html

    assert_equal expected_id, value
  end

  def test_find_returns_first_element_under_specified_namespace
    parser = RubyTcx::Parser.new(ns_tcx_file)
    root_element = parser.document.root
    expected_id = '2019-10-21T13:03:40.000Z'

    value = parser.find('//ns:Activity/ns:Id', root_element, 'ActivityExtension').inner_html

    assert_equal expected_id, value
  end

  def test_find_all_returns_elements_under_tcdb_namespace_by_default
    parser = RubyTcx::Parser.new(ns_tcx_file)
    root_element = parser.document.root
    expected_ids = ['2019-10-20T13:03:40.000Z', '2019-10-20T17:03:40.000Z']

    values = parser.find_all('//ns:Activity/ns:Id', root_element).map(&:inner_html)

    assert_equal 2, values.length
    assert_includes values, expected_ids[0]
    assert_includes values, expected_ids[1]
  end

  def test_find_all_returns_elements_under_other_specified_namespace
    parser = RubyTcx::Parser.new(ns_tcx_file)
    root_element = parser.document.root
    expected_ids = ['2019-10-21T13:03:40.000Z', '2019-10-21T17:03:40.000Z']

    values = parser.find_all('//ns:Activity/ns:Id', root_element, 'ActivityExtension').map(&:inner_html)

    assert_equal 2, values.length
    assert_includes values, expected_ids[0]
    assert_includes values, expected_ids[1]
  end
end