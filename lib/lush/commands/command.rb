#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module Lush
  module Commands
    # Base class for all built-in commands.
    class Command
      # Initializes the command with the supplied arguments.
      #
      # @param [Array<String>] args Arguments passed to the command.
      def initialize(*args)
        @args = args
      end

      # Executes the command according to the arguments.
      def execute
        raise NotImplementedError, 'Cannot execute a base Command'
      end
    end
  end
end
