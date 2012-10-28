module GithubLda
  module CLI
    COMMANDS = %w[clone calctf]

    def self.run
      command = ARGV.shift

      if COMMANDS.include? command
        load "github_lda/cli/#{command.tr('-', '_')}.rb"
      else
        puts <<-INFO
Usage:
  github_lda <command> [arguments]

Commands:
  #{COMMANDS.join(', ')}
INFO
      end
    end
  end
end
