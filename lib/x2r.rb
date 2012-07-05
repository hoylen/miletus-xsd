#!/usr/bin/env ruby
#
# = XML Schema to Ruby classes
#
# A command line program to convert one or more XML Schema files into
# one or more Ruby modules.
#
# For help, run with <code>--help</code>.

$VERBOSE = true

require 'x2r/xsd-info-ruby.rb'
require 'x2r/xmlobj/XSD'

#EOF
