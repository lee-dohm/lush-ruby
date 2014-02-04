#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module Lush
  # Encapsulates all the stream shuffling code for dealing with creating and managing pipelines.
  class Streams
    # Stream to use for `STDIN`.
    attr_reader :in

    # Stream to use for `STDOUT`.
    attr_reader :out

    # Initializes a new instance of the `Streams` class.
    def initialize
      @in = $stdin
      @out = $stdout
      @pipe = []
    end

    # Closes any finished streams.
    def close
      @out.close unless @out == $stdout
      @in.close unless @in == $stdin
      @in = @pipe.first
    end

    # Updates the stream values to the next stage in the pipeline.
    #
    # The `pipe` parameter should be true if there is another command in the pipeline and a set of
    # streams needs to be created to manage the pipeline. If the `pipe` parameter is false, then
    # `STDOUT` is set to be used as the outbound stream.
    #
    # @param [Boolean] pipe Flag indicating if there is another pipeline segment.
    def next(pipe: false)
      if pipe
        @pipe = IO.pipe
        @out = @pipe.last
      else
        @out = $stdout
      end
    end

    # Updates `STDIN` to point to `in`, if necessary.
    def reopen_in
      unless @in == $stdin
        $stdin.reopen(@in)
        @in.close
      end
    end

    # Updates `STDOUT` to point to `out`, if necessary.
    def reopen_out
      unless @out == $stdout
        $stdout.reopen(@out)
        @out.close
      end
    end
  end
end
