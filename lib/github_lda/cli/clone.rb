require 'github_lda'

file       = ARGV[0]
output_dir = ARGV[1]

if not File.exists?(file) or not File.directory?(output_dir) then
  puts <<-INFO
Usage:
  github_lda clone /path/to/repos.txt /path/to/output_dir

Synopsis:
  Clones all repositories specified in repos.txt into output_dir
INFO
  exit(0)
end

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
    GithubLda.clone_repo(git_path, clone_dir)
    sleep 1
  else
    puts "#{clone_dir} already exists, skipping"
  end
end
