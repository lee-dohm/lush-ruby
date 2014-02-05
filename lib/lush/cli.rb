#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

require 'shellwords'

module Lush
  # Handles the command-line interface of the shell.
  class CLI
    # List of built in commands and Command class.
    BUILTINS = {
      'cd' => Lush::Commands::ChangeDirectory,
      'exit' => Lush::Commands::ExitShell,
      'export' => Lush::Commands::ExportVariable
    }

    # Creates a new instance of the `CLI` class.
    def initialize
      init_prompt
    end

    # Executes the REPL.
    def run
      loop do
        print_prompt
        line = read_command_line
        commands = split_on_pipes(line)
        execute_commands(commands)
      end
    end

    private

    # Determines if `program` is a built-in command.
    #
    # @param [String] program Name of the program to execute.
    # @return [Boolean] Flag indicating whether `program` is a built-in command.
    def builtin?(program)
      BUILTINS.key?(program)
    end

    # Executes a built-in command.
    #
    # @param [String] program Name of the program to execute.
    # @param [Array<String>] arguments Arguments for the program.
    def call_builtin(program, *arguments)
      command = BUILTINS[program].new(*arguments)
      command.execute
    end

    # rubocop:disable MethodLength

    # Executes the list of commands.
    #
    # @param commands List of commands obtained from the command line.
    def execute_commands(commands)
      streams = Streams.new

      commands.each_with_index do |command, index|
        program, *arguments = Shellwords.shellsplit(command)

        if builtin?(program)
          call_builtin(program, *arguments)
        else
          streams.next(pipe: index + 1 < commands.size)
          spawn_program(program, *arguments, streams)
          streams.close
        end
      end

      Process.waitall
    end

    # rubocop:enable MethodLength

    # Gets the command line from the user.
    #
    # @return [String] Command-line text to execute.
    def read_command_line
      $stdin.gets.strip
    end

    # Initializes the command-line prompt string.
    def init_prompt
      ENV['PROMPT'] = '-> '
    end

    # Displays the prompt.
    def print_prompt
      $stdout.print(ENV['PROMPT'])
    end

    # Executes the given program in a sub-process.
    #
    # @param [String] program Name of the program to execute.
    # @param [Array<String>] arguments Arguments to supply to the program.
    # @param [Streams] streams Set of streams to use for input and output.
    def spawn_program(program, *arguments, streams)
      fork do
        # Must be done within the context of the fork to only reassign the standard streams in the
        # subprocess.
        streams.reopen

        exec program, *arguments
      end
    end

    # Splits a command line on pipe delimiters.
    #
    # @param [String] line Command line text.
    # @return [Array<String>] List of pipeline components.
    def split_on_pipes(line)
      line.scan(/([^"'|]+)|["']([^"']+)["']/).flatten.compact
    end
  end
end
