require 'github_lda/cloner'

require 'test/unit'

class TestCloner < Test::Unit::TestCase
  include GithubLda

  def test_clone_repo
    git_path = 'git@github.com:mrorii/github_lda.git'
    output_dir = '/tmp/github_lda' # ZOMG FIX ME. Use Mocha or fakefs
    Cloner.clone_repo(git_path, output_dir)
    assert Dir.exists?(output_dir) 
  end
end

