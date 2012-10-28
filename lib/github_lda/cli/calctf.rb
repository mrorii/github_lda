require 'github_lda'
require 'optparse'
require 'pathname'

info = <<-INFO
Usage:
  github_lda calctf -i /path/to/repo_dir -o /path/to/output_dir

Synopsis:
  Calculates the term frequency for each repository under repo_dir
  and outputs them into output_dir

Arguments:
  -i, --input     Path to root directory containing cloned repos
  -o, --output    Path to root directory where term frequency txt files will be written out
INFO

# parse command-line arguments
options = {}
optparse = OptionParser.new do |opts|
  opts.on('-i', '--input DIRECTORY') { |i| options[:input] = i }
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

Pathname.new(options[:input]).children.select { |c| c.directory? }.each do |dir|
  puts "Calculating term frequency for #{dir}"

  output_file = File.join(options[:output], "#{dir.basename}.txt")
  GithubLda.calc_tf(dir, output_file)
end

