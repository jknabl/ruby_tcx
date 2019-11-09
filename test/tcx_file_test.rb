require "test_helper"

class TcxFileTest < Minitest::Test
  attr_reader :file_name

  def setup
    @file_name = 'data/stwm2019.tcx'
  end

  def test_requires_a_file_name
    assert_raises ArgumentError do
      TcxFile.new
    end
  end

  def test_defaults_to_in_memory_parser
    assert_equal Parser, TcxFile.new(file_name: file_name).parser.class
  end

  def test_accepts_inmem_parser_method
    assert_equal Parser, TcxFile.new(file_name: file_name, parse_method: :memory).parser.class
  end

  def test_accepts_sax_parser_method
    assert_equal SaxParser, TcxFile.new(file_name: file_name, parse_method: :sax).parser.class
  end

  def test_accepts_string_input_for_parser_method
    assert_equal SaxParser, TcxFile.new(file_name: file_name, parse_method: 'sax').parser.class
  end

  def test_raises_on_invalid_parser_method
    assert_raises TcxFile::UnsupportedParseMethod do
      TcxFile.new(file_name: file_name, parse_method: :doesnt_exist).parser.class
    end
  end

  def test_instantiates_parser_with_instance_of_self
    file = TcxFile.new(file_name: file_name, parse_method: :memory)

    assert_equal file, file.parser.tcx_file
  end
end
