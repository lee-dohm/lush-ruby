#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module Lush
  module Commands
    # Represents the `exit` built-in command.
    class ExitShell
      # Status to return to the operating system upon exit.
      attr_reader :status

      # @param status Status to return to the operating system upon exit.
      def initialize(status = true)
        @status = status
      end

      # Executes the command.
      def execute
        exit(@status)
      end
    end
  end
end
