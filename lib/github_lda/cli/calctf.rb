require 'github_lda'
require 'github_lda/directory'
require 'optparse'

require 'parallel'

info = <<-INFO
Usage:
  github_lda calctf -i /path/to/repo_dir -o /path/to/otuput_dir \
    [--stopwords=/path/to/stopwords] [--lang=ruby,javascript] [--process=4]

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
  -p, --process   Number of processes to run on (defaults to 1)

INFO

# parse command-line arguments
options = { :process => 1 }
optparse = OptionParser.new do |opts|
  opts.on('-i', '--input DIRECTORY') { |i| options[:input] = i }
  opts.on('-o', '--output DIRECTORY') { |o| options[:output] = o }
  opts.on('-s', '--stopwords FILE') { |s| options[:stopwords] = s }
  opts.on('-l', '--lang LIST') { |l| options[:lang] = l }
  opts.on('-p', '--process NUM') { |p| options[:process] = p.to_i }
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

root_dir= GithubLda::Directory.new(options[:input])

Parallel.map(root_dir.all_repos_as_generator, :in_processes => options[:process]) do |dir|
  output_file = File.join(options[:output], "#{dir.basename}.txt")
  next if File.exist? output_file

  puts "Calculating term frequency for #{dir}"

  # ZOMG FIX ME: temporary rescue to suppress 'invalid byte sequence in UTF-8'
  begin
    repo = GithubLda::Repository.from_directory(dir)
  rescue
    next
  end

  if options[:lang]
    lang = options[:lang].split(',').map { |l| l.capitalize }
    term_frequency = repo.compute_termfreq(:lang => lang)
  else
    term_frequency = repo.compute_termfreq
  end

  # Only print out files that have more than one term in them
  next if term_frequency.count == 0

  open(output_file, 'w') do |f|
    term_frequency.sort.each do |term, frequency|
      f.puts("#{term}\t#{frequency}")
    end
  end
end

