#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module Lush
  module Commands
    # Represents the `cd` command.
    #
    # @see http://pubs.opengroup.org/onlinepubs/9699919799/utilities/cd.html#top POSIX shell cd
    #   command
    class ChangeDirectory < Command
      # Directory to which to change upon executing.
      attr_reader :directory

      # @param [Array<String>] args Arguments passed to the command.
      def initialize(*args)
        super(*args)

        @directory = @args.first
      end

      # Executes the `cd` command.
      def execute
        Dir.chdir(@directory)
      rescue Errno::ENOENT
        $stderr.puts "ChangeDirectory: No such directory: #{@directory}"
      end
    end
  end
end
