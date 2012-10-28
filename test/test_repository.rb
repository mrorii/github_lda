require 'github_lda/repository'

require 'test/unit'

class TestRepository < Test::Unit::TestCase
  include GithubLda

  def repo(base_path)
    Repository.from_directory(base_path)
  end

  def this_repo
    repo(File.expand_path("../..", __FILE__))
  end

  def test_compute_termfreq
    r = repo(File.expand_path("../../samples/Ruby", __FILE__))
    assert_equal({"foobar" =>2, "foo" => 1}, r.compute_termfreq)
  end
end
