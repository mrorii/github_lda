require 'github_lda/repository'

require 'test/unit'
require 'fakefs/safe'

class TestRepository < Test::Unit::TestCase
  include GithubLda

  def repo(base_path)
    Repository.from_directory(base_path)
  end

  def sample_repo
    repo(File.expand_path("../../samples/Ruby", __FILE__))
  end

  def test_compute_termfreq
    assert_equal({'foobar' => 1, 'foo' => 1}, sample_repo.compute_termfreq)
  end

  def test_each
    dir = File.expand_path("../../samples/Ruby", __FILE__)
    r = sample_repo
    count = 0

    r.instance_eval do
      @enum.each do |blob|
        count += 1
      end
    end

    assert_equal Dir["#{dir}/*"].length, count
  end
end
