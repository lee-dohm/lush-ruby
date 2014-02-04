#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

require 'shellwords'

module Lush
  # Handles the command-line interface of the shell.
  class CLI
    # List of built in commands and their implementation.
    BUILTINS = {
      'cd' => lambda { |dir| Dir.chdir(dir) },
      'exit' => lambda { |code = 0| exit(code.to_i) },
      'export' => lambda { |args|
        key, value = args.split('=')
        ENV[key] = value
      }
    }

    # Creates a new instance of the `CLI` class.
    def initialize
      ENV['PROMPT'] = '-> '
    end

    # Starts the shell.
    def run
      loop do
        $stdout.print(ENV['PROMPT'])
        line = $stdin.gets.strip

        commands = split_on_pipes(line)

        fd_in = $stdin
        fd_out = $stdout
        pipe = []

        commands.each_with_index do |command, index|
          program, *arguments = Shellwords.shellsplit(command)

          if builtin?(program)
            call_builtin(program, *arguments)
          else
            if index + 1 < commands.size
              pipe = IO.pipe
              fd_out = pipe.last
            else
              fd_out = $stdout
            end

            spawn_program(program, *arguments, fd_out, fd_in)

            fd_out.close unless fd_out == $stdout
            fd_in.close unless fd_in == $stdin
            fd_in = pipe.first
          end
        end

        Process.waitall
      end
    end

    private

    # Determines if `program` is a built-in command.
    #
    # @param [String] program Name of the program to execute.
    # @return [Boolean] Flag indicating whether `program` is a built-in command.
    def builtin?(program)
      BUILTINS.has_key?(program)
    end

    # Executes a built-in command.
    #
    # @param [String] program Name of the program to execute.
    # @param [Array<String>] arguments Arguments for the program.
    def call_builtin(program, *arguments)
      BUILTINS[program].call(*arguments)
    end

    # Executes the given program in a sub-process.
    #
    # @param [String] program Name of the program to execute.
    # @param [Array<String>] arguments Arguments to supply to the program.
    # @param [IO] fd_out IO object containing the file descriptor for the program to use as its STDOUT.
    # @param [IO] fd_in IO object containing the file descriptor for the program to use as its STDIN.
    def spawn_program(program, *arguments, fd_out, fd_in)
      fork {
        unless fd_out == $stdout
          $stdout.reopen(fd_out)
          fd_out.close
        end

        unless fd_in == $stdin
          $stdin.reopen(fd_in)
          fd_in.close
        end

        exec program, *arguments
      }
    end

    # Splits a command line on pipe delimiters.
    #
    # @param [String] line Command line text.
    # @return [Array<String>] List of pipeline components.
    def split_on_pipes(line)
      line.scan( /([^"'|]+)|["']([^"']+)["']/ ).flatten.compact
    end
  end
end
