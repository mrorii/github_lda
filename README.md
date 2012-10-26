# GitHub LDA - Collaborative Topic Modeling for Recommending Github Repos

## What is GitHub LDA?

GitHub LDA is a library that applies topic modeling on GitHub repos to improve repository recommendation.

## Usage

### Download the Github Contest dataset

    wget https://github.s3.amazonaws.com/data/download.zip
    unzip download.zip

### Clone the git repositories from GitHub

    github_lda clone /path/to/repos.txt --output /tmp

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

