require 'github_lda/repository'

require 'test/unit'
require 'fakefs/safe'

class TestRepository < Test::Unit::TestCase
  include GithubLda

  def setup
    @ruby_dir = File.expand_path("../../samples/Ruby", __FILE__)
    @mix_dir  = File.expand_path("../../samples/RubyPython", __FILE__)
  end

  def repo(base_path)
    Repository.from_directory(base_path)
  end

  def sample_ruby_repo
    repo(@ruby_dir)
  end

  def sample_mix_repo
    repo(@mix_dir)
  end

  def test_compute_termfreq
    assert_equal({'foobar' => 1, 'foo' => 1}, sample_ruby_repo.compute_termfreq)
  end

  def test_compute_termfreq_lang
    assert_equal({'foobar' => 1, 'foo' => 1},
                 sample_ruby_repo.compute_termfreq(:lang => ['Ruby']))
    assert_equal({},
                 sample_ruby_repo.compute_termfreq(:lang => ['Python']))
    assert_equal({'bar' => 1},
                 sample_mix_repo.compute_termfreq(:lang => ['Ruby']))
    assert_equal({'foo' => 1},
                 sample_mix_repo.compute_termfreq(:lang => ['Python']))
    assert_equal({},
                 sample_mix_repo.compute_termfreq(:lang => ['Perl']))
  end

  def test_each
    r = sample_ruby_repo
    count = 0

    r.instance_eval do
      @enum.each do |blob|
        count += 1
      end
    end

    assert_equal Dir["#{@ruby_dir}/*"].length, count
  end
end
