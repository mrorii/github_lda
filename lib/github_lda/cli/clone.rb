require 'github_lda'
require 'optparse'
require 'ostruct'

file = ARGV[0]
if not file or not File.exists?(file) then
  puts <<-INFO
Usage:
  github_lda [options] </path/to/repos.txt>

Synopsis:
  Clones all repositories specified in repos.txt

Options:
  -o, --output dir      Directory to clone repositories to. Defaults to current directory
INFO
  exit(0)
end

options = OpenStruct.new
options.output_dir = "."

# parse command-line options
opts = OptionParser.new
opts.on('-o', '--output dir') {|dir| options.output_dir = dir }
opts.parse!(ARGV)

GithubLda.clone_repos(file, options.output_dir)
