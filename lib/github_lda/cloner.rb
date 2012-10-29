require 'grit'

module GithubLda
  class Cloner
    def self.clone_repo(git_path, output_dir)
      repo = Grit::Git.new('/tmp/tmp') # FIX ME
      process = repo.clone(
        { :process_info => true, :progress => true, :timeout => false },
        git_path,
        output_dir
      )
    end
  end
end
