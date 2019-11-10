module RubyTcx
  class TcxFile
    class UnsupportedParseMethod < StandardError; end
    class FileNotFound < StandardError; end
    class PathNotFile < StandardError; end

    # Responsible for transforming a text TCX file into a collection of Nokogiri elements.
    attr_reader :file_name, :parse_method, :parser

    def initialize(file_name:, parse_method: :memory)
      @file_name = file_name
      validate_file

      @parse_method = parse_method
      @parser = parser_klass.new(self)
    end

    def namespaces
      {
        'TrainingCenterDatabase' => 'http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2',
        'ActivityExtension' => 'http://www.garmin.com/xmlschemas/ActivityExtension/v2',
      }
    end

    private

    def validate_file
      raise FileNotFound, 'No TCX file found at given path.' unless File.exist?(file_name)
      raise PathNotFile, 'Given path is not a file (e.g., may be a directory).' unless File.file?(file_name)
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
