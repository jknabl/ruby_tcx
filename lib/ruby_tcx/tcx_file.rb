module RubyTcx
  class TcxFile
    class UnsupportedParseMethod < StandardError; end
    # Responsible for transforming a text TCX file into a collection of Nokogiri elements.
    attr_reader :file_name, :parse_method, :parser

    def initialize(file_name:, parse_method: :memory)
      @file_name = file_name
      @parse_method = parse_method
      @parser = parser_klass.new(self)
    end

    private

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
