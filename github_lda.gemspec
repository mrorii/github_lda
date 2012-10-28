# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_lda/version'

Gem::Specification.new do |gem|
  gem.name          = "github_lda"
  gem.version       = GithubLda::VERSION
  gem.authors       = ["Naoki Orii"]
  gem.email         = ["mrorii@gmail.com"]
  gem.description   = %q{Collaborative Topic Modeling for Github Repos}
  gem.summary       = %q{Collaborative Topic Modeling for Github Repos}
  gem.homepage      = "https://github.com/mrorii/github_lda"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "grit", ">= 2.5.0"
  gem.add_runtime_dependency "github-linguist", ">= 2.3.4"
  gem.add_runtime_dependency "nokogiri", ">= 1.5.5"
  # gem.add_runtime_dependency "pygments.rb", ">= 0.3.2"
end
