module GithubLda
  class Tokenizer
    def initialize
      @word_ptn = Regexp.new('[A-Za-z]+')
      @camelcase_splitter = Regexp.new('(?=[A-Z])')
    end

    def tokenize(str)
      words = str.scan(@word_ptn)

      retval = []
      words.each do |word|
        tokens = word.split @camelcase_splitter

        tokens.each do |token|
          retval << token.downcase
        end
      end

      retval
    end
  end
end
