require 'github_lda/version'
require 'grit'

module GithubLda
  # Public: Clones a single repo
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

  # Public: Caculates the term frequency for a single repo
  #
  # dir           - Term frequency is calculated for this directory
  # output_file   - Path to write the term frequency into
  def self.calc_tf(dir, output_file)
    # Call python code
    `python python/calculate_tf.py --input #{dir} --output #{output_file}`
  end
end
