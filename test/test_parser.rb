require 'github_lda/parser'

require 'test/unit'

class TestParser < Test::Unit::TestCase
  include GithubLda

  def setup
    @parser = Parser.new
  end

  def test_parse
    assert_equal(['foo'], @parser.parse('<span class="s1">foo</span>'))
  end

  def test_parse_multiple
    assert_equal(['foo', 'bar'], @parser.parse(
      '<span class="s1">foo</span><span class="nv">bar</span>'
    ))
  end

  def test_parse_skips_not_allowed_class
    assert_equal(['foo', 'bar'], @parser.parse(
      '<span class="s1">foo</span><span class="baz">baz</span><span class="nv">bar</span>'
    ))
  end

  def test_parse_empty
    assert_equal([], @parser.parse(
      '<span class="bar">foo</span><span class="baz">baz</span><span class="bar">bar</span>'
    ))
  end
end
