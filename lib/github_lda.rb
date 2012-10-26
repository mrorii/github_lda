require 'github_lda/version'
require 'grit'

module GithubLda
  # Public: Clones repositories given by +file+
  #
  # file       - Path to repos.txt
  # output_dir - Path to clone the repositories into.
  def self.clone_repos(file, output_dir)
    repos = File.open(file, 'r') do |f|
      retval = []
      f.each do |line|
        m, repo_id, repo_name = *line.match(/^(\d+):(\S+\/\S+?),/)
        retval << [repo_id, repo_name]
      end
      retval
    end

    repos.each do |repo_id, repo_name|
      git_path = "git://github.com/#{repo_name}.git"

      clone_dir = File.join(output_dir, repo_id)
      if not File.exists?(clone_dir)
        puts "Cloning #{git_path} into #{clone_dir}"
        clone_repo(git_path, clone_dir)
        sleep 1
      else
        puts "#{clone_dir} already exists, skipping"
      end
    end
  end

  private

  # Private: Clones a single repo
  #
  # git_path   - Repository's git URL
  # output_dir - Path to close the repository into.
  def self.clone_repo(git_path, output_dir)
    repo = Grit::Git.new('/tmp/tmp') # FIX ME
    process = repo.clone(
      { :process_info => true, :progress => true, :timeout => false },
      git_path,
      output_dir
    )
  end
end
