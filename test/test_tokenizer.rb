require 'github_lda/tokenizer'

require 'test/unit'

class TestTokenizer < Test::Unit::TestCase
  include GithubLda

  def setup
    @t = Tokenizer.new
  end

  def test_tokenize_basic
    assert_equal(['foo', 'bar'], @t.tokenize('foo bar'))
    assert_equal(['foobar'], @t.tokenize('foobar'))
  end

  def test_tokenize_lowercase
    assert_equal(['foo', 'bar'], @t.tokenize('foo Bar'))
    assert_equal(['foo', 'bar'], @t.tokenize('Foo Bar'))
    assert_equal(['foo', 'bar'], @t.tokenize('FOO Bar'))
    assert_equal(['foo', 'bar'], @t.tokenize('FOO BAR'))
    assert_equal(['foo', 'bar'], @t.tokenize('foo BAR'))
    assert_equal(['foo', 'bar'], @t.tokenize('Foo BAR'))
  end

  def test_tokenize_camelcase
    assert_equal(['foo', 'bar'], @t.tokenize('fooBar'))
    assert_equal(['foo', 'bar'], @t.tokenize('FooBar'))
    assert_equal(['foobar'], @t.tokenize('Foobar'))
  end

  def test_tokenize_nonalpha
    assert_equal(['foobar', 'baz'], @t.tokenize('foobar1 $baz'))
    assert_equal(['foobar', 'baz'], @t.tokenize('"Foobar" baz,'))
    assert_equal(['foobar'], @t.tokenize('"foobar"'))
  end
end

