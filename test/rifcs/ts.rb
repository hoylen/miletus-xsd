#!/usr/bin/env ruby
# RIF-CS test suite.

$VERBOSE = true

BASEDIR = File.expand_path(File.dirname(__FILE__))

# Include all the RIF-CS test cases

require "#{BASEDIR}/example/tc.rb"
require "#{BASEDIR}/registryObjects/tc.rb"
require "#{BASEDIR}/party/tc.rb"
# require "#{BASEDIR}/collection/tc.rb"

#EOF
