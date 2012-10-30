require 'github_lda'
require 'github_lda/directory'
require 'optparse'

info = <<-INFO
Usage:
  github_lda clone -i /path/to/repos.txt -o /path/to/repo_dir

Synopsis:
  Clones all repositories

Arguments:
  -i, --input     Path to repos.txt
  -o, --output    Path to clone the repositories into
INFO

# parse command-line arguments
options = {}
optparse = OptionParser.new do |opts|
  opts.on('-i', '--input FILE') { |i| options[:input] = i }
  opts.on('-o', '--output DIRECTORY') { |o| options[:output] = o }
end

begin
  optparse.parse!
  mandatory = [:input, :output]
  missing = mandatory.select{ |param| options[param].nil? }
  if not missing.empty?
    puts "Missing arguments: #{missing.join(', ')}"
    puts info
    exit(1)
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts optparse
  exit
end

def each_repo(file)
  repos = File.open(file, 'r') do |f|
    f.each do |line|
      m, repo_id, repo_name = *line.match(/^(\d+):(\S+\/\S+?),/)
      yield repo_id, repo_name
    end
  end
end

each_repo(options[:input]) do |repo_id, repo_name|
  git_path = "git://github.com/#{repo_name}.git"

  root_dir = GithubLda::Directory.new(options[:output])
  clone_dir = root_dir.path(repo_id)

  if not File.exists?(clone_dir)
    puts "Cloning #{git_path} into #{clone_dir}"
    GithubLda::Cloner.clone_repo(git_path, clone_dir)
    sleep 1
  else
    puts "#{clone_dir} already exists, skipping"
  end
end
