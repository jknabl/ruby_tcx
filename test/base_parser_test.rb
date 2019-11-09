require 'test_helper'

class BaseParserTest < Minitest::Test
  def test_requires_tcx_file
    assert_raises ArgumentError do
      BaseParser.new
    end
  end
end