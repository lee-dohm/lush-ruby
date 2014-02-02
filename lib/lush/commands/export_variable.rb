#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module Lush
  module Commands
    # Represents the `export` built-in command.
    #
    # @see http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_22
    #   POSIX shell export command
    class ExportVariable
      # Environment to modify. Defaults to `ENV`.
      attr_writer :env

      def initialize(*args)
        @env = ENV
        @args = args
      end

      # Executes the command.
      #
      # @return [nil]
      def execute
        case
        when @args.empty?
          dump_environment
        when @args.first == '-p'
          dump_environment(export_prefix: true)
        else
          set_variable
        end
      end

      private

      # Dumps the environment to standard out.
      #
      # @param [Boolean] export_prefix Flag indicating whether to print the `export` prefix before
      #   the environment variable on each line.
      def dump_environment(export_prefix: false)
        prefix = 'export ' if export_prefix

        @env.keys.sort.each { |k| $stdout.puts "#{prefix}#{k}=#{@env[k]}" }
      end

      # Sets the variable.
      def set_variable
        key = @args.first
        value = @args[1].empty? ? nil : @args[1]

        @env[key] = value
      end
    end
  end
end
