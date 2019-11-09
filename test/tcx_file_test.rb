require "test_helper"

class TcxFileTest < Minitest::Test
  attr_reader :file_name

  def setup
    @file_name = RubyTcx::TestConfig::DEFAULT_FIXTURE_PATH
  end

  def test_requires_a_file_name
    assert_raises ArgumentError do
      RubyTcx::TcxFile.new
    end
  end

  def test_defaults_to_in_memory_parser
    file = RubyTcx::TcxFile.new(file_name: file_name)

    assert_equal RubyTcx::Parser, file.parser.class
  end

  def test_accepts_inmem_parser_method
    file = RubyTcx::TcxFile.new(file_name: file_name, parse_method: :memory)

    assert_equal RubyTcx::Parser, file.parser.class
  end

  def test_accepts_sax_parser_method
    file = RubyTcx::TcxFile.new(file_name: file_name, parse_method: :sax)

    assert_equal RubyTcx::SaxParser, file.parser.class
  end

  def test_accepts_string_input_for_parser_method
    file = RubyTcx::TcxFile.new(file_name: file_name, parse_method: 'sax')

    assert_equal RubyTcx::SaxParser, file.parser.class
  end

  def test_raises_on_invalid_parser_method
    assert_raises RubyTcx::TcxFile::UnsupportedParseMethod do
      RubyTcx::TcxFile.new(file_name: file_name, parse_method: :doesnt_exist)
    end
  end

  def test_instantiates_parser_with_instance_of_self
    file = RubyTcx::TcxFile.new(file_name: file_name, parse_method: :memory)

    assert_equal file, file.parser.tcx_file
  end

  def test_opens_file
    file = RubyTcx::TcxFile.new(file_name: file_name)

    assert_kind_of File, file.file
  end

  def test_raises_if_file_is_not_file
    assert_raises RubyTcx::TcxFile::PathNotFile do
      RubyTcx::TcxFile.new(file_name: RubyTcx::TestConfig::FIXTURE_DIR)
    end
  end

  def test_raises_if_no_file_at_path
    assert_raises RubyTcx::TcxFile::FileNotFound do
      RubyTcx::TcxFile.new(file_name: 'this/doesnt/exist')
    end
  end
end
