require 'github_lda'
require 'github_lda/directory'
require 'optparse'

info = <<-INFO
Usage:
  github_lda calctf -i /path/to/repo_dir -o /path/to/otuput_dir \
    [--stopwords=/path/to/stopwords] [--lang=ruby,javascript]

Synopsis:
  Calculates the term frequency for each repository under repo_dir
  and outputs them into output_dir

Arguments:
  -i, --input     Path to root directory containing cloned repos
  -o, --output    Path to root directory where term frequency txt files will be written out

Options:
  -s, --stopwords Stopwords file (default is stopwords provided by nltk)
  -l, --lang      Comma-separated list of languages to consider.
                  List of available languages are at:
                      https://github.com/github/linguist/blob/master/lib/linguist/languages.yml

INFO

# parse command-line arguments
options = {}
optparse = OptionParser.new do |opts|
  opts.on('-i', '--input DIRECTORY') { |i| options[:input] = i }
  opts.on('-o', '--output DIRECTORY') { |o| options[:output] = o }
  opts.on('-s', '--stopwords FILE') { |s| options[:stopwords] = s }
  opts.on('-l', '--lang LIST') { |l| options[:lang] = l }
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

GithubLda::Directory.new(options[:input]).each do |dir|
  puts "Calculating term frequency for #{dir}"
  repo = GithubLda::Repository.from_directory(dir)

  if options[:lang]
    lang = options[:lang].split(',').map { |l| l.capitalize }
    term_frequency = repo.compute_termfreq(:lang => lang)
  else
    term_frequency = repo.compute_termfreq
  end

  # Only print out files that have more than one term in them
  next if term_frequency.count == 0

  output_file = File.join(options[:output], "#{dir.basename}.txt")
  open(output_file, 'w') do |f|
    term_frequency.sort.each do |term, frequency|
      f.puts("#{term}\t#{frequency}")
    end
  end
end

