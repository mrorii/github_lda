require 'github_lda/parser'

require 'test/unit'

class TestParser < Test::Unit::TestCase
  include GithubLda

  HTML_CODE = '<span class="s1">foo</span>'

  def test_parse_simple
    parser = GithubLda::Parser.new
    assert_equal(['foo'], parser.parse(HTML_CODE))
  end
end
