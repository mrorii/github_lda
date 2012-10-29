module GithubLda
  class Directory
    attr_reader :modulo

    def initialize(root_dir, modulo=10000)
      @root_dir = root_dir
      @modulo = modulo
    end

    def path(repo_id, extname='txt')
      Dir.mkdir(@root_dir) if not Dir.exists?(@root_dir)

      sub_dir = File.join(@root_dir, (repo_id.to_i / @modulo).to_s)
      Dir.mkdir(sub_dir) if not Dir.exists?(sub_dir)

      File.join(sub_dir, "#{repo_id}.#{extname}")
    end
  end
end

