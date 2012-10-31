require 'pathname'

module GithubLda
  class Directory
    attr_reader :modulo

    def initialize(root_dir, modulo=10000)
      @root_dir = root_dir
      @modulo = modulo
    end

    def path(repo_id, extname=nil)
      Dir.mkdir(@root_dir) if not Dir.exists?(@root_dir)

      sub_dir = File.join(@root_dir, (repo_id.to_i / @modulo).to_s)
      Dir.mkdir(sub_dir) if not Dir.exists?(sub_dir)

      if extname
        return File.join(sub_dir, "#{repo_id}.#{extname}")
      else
        return File.join(sub_dir, "#{repo_id}")
      end
    end

    # Yields all repos
    def each
      Pathname.new(@root_dir).children.select { |c| c.directory? }.each do |child_dir|
        child_dir.children.select { |g| g.directory? }.each do |grandchild_dir|
          yield grandchild_dir
        end
      end
    end

    # Returns all repos as python-like generators
    def all_repos_as_generator
      Enumerator.new do |enum|
        each do |repo|
          enum.yield repo
        end
      end
    end
  end
end

