module RubyTcx
  class TcxFile
    class UnsupportedParseMethod < StandardError; end
    class FileNotFound < StandardError; end
    class PathNotFile < StandardError; end

    # Responsible for transforming a text TCX file into a collection of Nokogiri elements.
    attr_reader :file_name, :parse_method, :parser, :file

    def initialize(file_name:, parse_method: :memory)
      @file_name = file_name
      @file = load_file
      @parse_method = parse_method
      @parser = parser_klass.new(self)
    end

    private

    def load_file
      raise FileNotFound, 'No TCX file found at given path.' unless File.exist?(file_name)

      file = File.open(file_name)

      raise PathNotFile, 'Given path is not a file (e.g., may be a directory).' unless File.file?(file)
      file
    end

    def parser_klass
      case parse_method.to_sym
      when :memory
        Parser
      when :sax
        SaxParser
      else
        raise UnsupportedParseMethod, 'Please use a supported parse method: [memory, sax]'
      end
    end
  end
end
