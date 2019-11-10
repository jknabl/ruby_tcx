require 'test_helper'

class ParserTest < Minitest::Test
  def setup
    @tcx_file = RubyTcx::TcxFile.new(file_name: RubyTcx::TestConfig::DEFAULT_FIXTURE_PATH)
  end

  def test_tcx_file_is_required
    assert_raises ArgumentError do
      RubyTcx::Parser.new
    end
  end

  def test_parse_creates_activity
    parser = RubyTcx::Parser.new(@tcx_file)

    assert_kind_of RubyTcx::Activity, parser.parse
  end
end