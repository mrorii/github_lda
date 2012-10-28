require 'github_lda/version'
require 'github_lda/repository'

require 'grit'

module GithubLda
  # Public: Clones a single repo
  #
  # git_path   - Repository's git URL
  # output_dir - Path to clone the repository into.
  def self.clone_repo(git_path, output_dir)
    repo = Grit::Git.new('/tmp/tmp') # FIX ME
    process = repo.clone(
      { :process_info => true, :progress => true, :timeout => false },
      git_path,
      output_dir
    )
  end
end
