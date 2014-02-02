#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

require 'lush'

include Lush::Commands

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
root = File.expand_path('../..', __FILE__)
Dir[File.join(root, 'spec/support/**/*.rb')].each { |f| require f }
