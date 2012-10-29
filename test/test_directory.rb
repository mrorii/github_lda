require 'github_lda/directory'

require 'test/unit'

class TestDirectory < Test::Unit::TestCase
  include GithubLda

  def setup
    @root_dir = '/tmp/github_lda_dir' # ZOMG FIX ME. Use Mocha of fakefs
    @d = Directory.new(@root_dir)
  end

  def test_path
    ['1', '9999', '10000', '10001'].each do |repo_id|
      path = @d.path(repo_id) 

      div = repo_id.to_i / @d.modulo
      assert Dir.exists?(@root_dir)
      assert Dir.exists?(File.join(@root_dir, div.to_s))
    end
  end
end

