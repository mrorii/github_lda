# Collaborative Topic Modeling for Recommending Github Repos

## What is GitHub LDA?

GitHub LDA is a library that applies topic modeling on GitHub repos to improve repository recommendation.

## Usage

### Download the GitHub Contest dataset

    wget https://github.s3.amazonaws.com/data/download.zip
    unzip download.zip

### Clone the git repositories from GitHub

    mkdir repo_dir
    github_lda clone -i download/repos.txt -o repo_dir [-p 4]

As there are around 120,000 repositories to download, this will take a VERY long time and will eat up a huge chunk of disk space (up to 1TB). You can specify the number of clones to run in parallel by using the -p option. In order to avoid the number of directories limit in \*nix, by default it will subdivide the repositories into 13 subdirectories as follows:

    repo_dir
    |---0
    |   |---1
    |   |---2
    |   |---...
    |   `---9999
    |---1
    |   |---10000
    |   |---10001
    |   |---...
    .
    |   `---119999
    `---12
        |---120000
        |---120001
        |---...
        `---123344

### Calculate the term frequency for each repository

    mkdir term_freq_dir
    github_lda calctf -i repo_dir -o term_freq_dir [--stopwords=/path/to/stopwords] [--lang=ruby,javascript] [--process=1]

You can limit the repositories of interest by using the --lang option. By default, term frequencies for source files of all programming languages will be calculated. Refer [here][lang] for the list of available language options. You can also specify the number of processors to run on by using the --process option.

### Preprocess the corpus and convert it into lda-c format and ctr format data

Generate mult.dat, user.dat, item.dat, and vocab.dat in specified directory

    mkdir data
    github_lda generate --tf term_freq_dir -i download/data.txt -o data

### Run lda-c-dist

    mkdir lda-result
    lda est 0.1 100 settings.txt data/mult.dat random lda-result

### Run ctr

    ctr --user data/user.dat --item data/item.dat --mult mult.dat \
      --theta_init lda-result/final.gamma --beta_init lda-result/final.beta

## Resources

+ [Wikipedia article on LDA][wikipedia]
+ [Official GitHub Blog post: The 2009 GitHub Contest][blog1]
+ [Official GitHub Blog post: About the GitHub Contest][blog2]

## References

Chong Wang and David M. Blei. 2011. Collaborative Topic Modeling for Recommending Scientific Articles. In Proc of KDD'11  [[pdf][pdf]].

[pdf]: http://www.cs.cmu.edu/~chongw/papers/WangBlei2011.pdf
[wikipedia]: http://en.wikipedia.org/wiki/Latent_Dirichlet_allocation
[blog1]: https://github.com/blog/466-the-2009-github-contest
[blog2]: https://github.com/blog/481-about-the-github-contest
[data]: https://github.s3.amazonaws.com/data/download.zip
[lang]: https://github.com/github/linguist/blob/master/lib/linguist/languages.yml

