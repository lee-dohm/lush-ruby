#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module Lush
  module Commands
    # Represents the `cd` command.
    class ChangeDirectory
      # Directory to which to change upon executing.
      attr_reader :directory

      # @param path Directory to which to change.
      def initialize(path)
        @directory = path
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
