require 'cgi'
require 'linguist'

require 'github_lda/parser'
require 'github_lda/tokenizer'

module GithubLda
  # A simple wrapper over Linguist::Repository
  class Repository
    # Public: Initialize a new Repository from a File directory
    #
    # base_path - A path String
    #
    # Returns a Repository
    def self.from_directory(base_path)
      new Dir["#{base_path}/**/*"].
        select { |f| File.file?(f) }.
        map { |path| Linguist::FileBlob.new(path, base_path) }
    end

    # Public: Initialize a new Repository
    #
    # enum - Enumerator that responds to `each` and
    #        yields Linguist::FileBlob objects
    #
    # Returns a Repository
    def initialize(enum)
      @enum = enum
      @computed_termfreq = false
      @termfreq = Hash.new { 0 }
      @parser = Parser.new
      @tokenizer = Tokenizer.new
    end

    # Publlic: Compute the aggregate term frequency for each blob in the Repository.
    #
    # Returns a Hash with the term (String) as key and value (Fixnum) as value.
    def compute_termfreq
      return @termfreq if @computed_termfreq

      @enum.each do |blob|
        # Skip binary file extensions
        next if blob.binary_mime_type?

        # Skip vendored or generated blobs
        next if blob.vendored? || blob.generated? || blob.language.nil?

        # Only include programming languages
        if blob.language.type == :programming
          words = []

          # Linguist::FileBlob#safe_to_colorize? can fail
          # with "invalid byte sequence in UTF-8"
          begin
            if blob.safe_to_colorize?
              words = @parser.parse(CGI.unescapeHTML(blob.colorize()))
            end
          rescue
            # do nothing
          end
  
          words.each do |word|
            tokens = @tokenizer.tokenize(word)
            tokens.each do |token|
              @termfreq[token] += 1
            end
          end
        end
      end

      @computed_termfreq = true

      @termfreq
    end
  end
end
