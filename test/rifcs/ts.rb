#!/usr/bin/env ruby
# RIF-CS test suite.

$VERBOSE = true

# Include all the RIF-CS test cases

$input_dir = 'example/'
require 'example/tc.rb'

$input_dir = 'registryObjects/'
require 'registryObjects/tc.rb'

$input_dir = 'party/'
require 'party/tc.rb'

# $input_dir = 'collection/'
# require 'collection/tc.rb'

#EOF
