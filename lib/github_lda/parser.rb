require 'yaml'
require 'nokogiri'

module GithubLda
  # A Document is an abstraction of an HTML document
  class Document < Nokogiri::XML::SAX::Document
    # Path for the allowed token classes
    PATH = File.expand_path('../allowed_classes.yml', __FILE__)

    # Array of allowed token classes
    if File.exist?(PATH)
      ALLOWED_CLASSES = YAML.load_file(PATH)
    end

    attr_reader :tokens
  
    def initialize
      super
      @tokens = [] # stores the tokens
    end
  
    def start_element(name, attributes=[])
      if name == 'span'
        attributes.each do |attrib, value|
          if attrib == 'class' and ALLOWED_CLASSES.include? value
            @extract = true
            break
          end
        end
      end
    end
  
    def end_element(name)
      @extract = false
    end
  
    def characters(str)
      if @extract
        @tokens << str.strip
      end
    end
  end

  class Parser
    def parse(html)
      doc = Document.new
      Nokogiri::HTML::SAX::Parser.new(doc).parse(html)
      doc.tokens
    end
  end
end

