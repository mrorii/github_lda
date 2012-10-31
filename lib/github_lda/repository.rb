require 'cgi'
require 'linguist'

require 'github_lda/parser'
require 'github_lda/tokenizer'

module GithubLda
  # A simple class over representing a repository.
  # Stores an enumerator of Linguist::Fileblob objects
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
    def compute_termfreq(options={})
      return @termfreq if @computed_termfreq

      @enum.each do |blob|
        # Skip binary file extensions
        next if blob.binary_mime_type?

        # Linguist::FileBlob#generated? can fail
        # with "invalid byte sequence in UTF-8"
        begin
          # Skip vendored or generated blobs
          next if blob.vendored? || blob.generated? || blob.language.nil?
        rescue
          next
        end

        # Only include programming languages
        if blob.language.type == :programming
          # Skip if lang option is on and this blob is not in the list of specified languages
          next if options[:lang] and not options[:lang].include? blob.language.name

          words = []

          # Linguist::FileBlob#safe_to_colorize? can similarly fail
          # with "invalid byte sequence in UTF-8"
          begin
            if blob.safe_to_colorize?
              words = @parser.parse(CGI.unescapeHTML(blob.colorize()))
            end
          rescue
            next
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
