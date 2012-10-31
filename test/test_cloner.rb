require 'github_lda/cloner'

require 'test/unit'
require 'fileutils'

class TestCloner < Test::Unit::TestCase
  include GithubLda

  def setup
    @output_dir = '/tmp/github_lda' # ZOMG FIX ME. Use Mocha or fakefs
  end

  def teardown
    FileUtils.rm_rf(@output_dir)
  end

  def test_clone_repo
    git_path = 'git@github.com:mrorii/github_lda.git'
    Cloner.clone_repo(git_path, @output_dir)
    assert Dir.exists?(@output_dir)
  end
end

