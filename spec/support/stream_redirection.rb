#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Redirects standard streams into `StringIO` objects to capture the output of code.
def redirect_standard_streams
  $stdout = StringIO.new
  $stderr = StringIO.new
end

# Resets standard streams to normal.
def reset_standard_streams
  $stdout = STDOUT
  $stderr = STDERR
end
