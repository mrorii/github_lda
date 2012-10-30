require 'github_lda/directory'

require 'test/unit'
require 'fileutils'

class TestDirectory < Test::Unit::TestCase
  include GithubLda

  def setup
    @root_dir = '/tmp/github_lda_dir' # ZOMG FIX ME. Use Mocha of fakefs
    @d = Directory.new(@root_dir)
  end

  def cleanup
    FileUtils.rm_rf(@root_dir)
  end

  def teardown
    cleanup
  end

  def test_path_for_file
    extname = 'txt'

    ['1', '9999', '10000', '10001'].each do |repo_id|
      path = @d.path(repo_id, extname=extname)

      div = repo_id.to_i / @d.modulo
      sub_dir = File.join(@root_dir, div.to_s)
      assert Dir.exists?(@root_dir)
      assert Dir.exists?(sub_dir)
      assert_equal File.join(sub_dir, "#{repo_id}.#{extname}"), path
    end
    cleanup
  end

  def test_path_for_dir
    ['1', '9999', '10000', '10001'].each do |repo_id|
      path = @d.path(repo_id) 

      div = repo_id.to_i / @d.modulo
      sub_dir = File.join(@root_dir, div.to_s)
      assert Dir.exists?(@root_dir)
      assert Dir.exists?(sub_dir)
      assert_equal File.join(sub_dir, repo_id.to_s), path
    end
    cleanup
  end

  def test_each
    Dir.mkdir(@root_dir)
    sub_dirs = [
      File.join(@root_dir, '0', '1'),
      File.join(@root_dir, '0', '2'),
      File.join(@root_dir, '1', '10000'),
      File.join(@root_dir, '1', '100001'),
      File.join(@root_dir, '2', '20000'),
    ]

    sub_dirs.each do |dir|
      FileUtils.mkdir_p dir
    end

    count = 0
    @d.each do |dir|
      count += 1
    end

    assert_equal sub_dirs.count, count
    cleanup
  end
end

