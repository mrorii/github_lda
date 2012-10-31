module GithubLda
  class Tokenizer
    def initialize
      @word_ptn = Regexp.new('[A-Za-z]+')
    end

    def tokenize(str)
      words = str.scan(@word_ptn)

      retval = []
      words.each do |word|
        # deal with camel case
        tokens = word.gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').
                      gsub(/([a-z\d])([A-Z])/,'\1 \2').
                      split(' ')

        tokens.each do |token|
          retval << token.downcase
        end
      end

      retval
    end
  end
end
