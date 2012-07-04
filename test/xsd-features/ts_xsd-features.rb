#!/usr/bin/env ruby
# XSD features test suite.

$VERBOSE = true

INPUTDIR = File.expand_path(File.dirname(__FILE__))

# Include all the XSD features test cases

require "#{INPUTDIR}/attributeGroup/tc_attributeGroup.rb"
require "#{INPUTDIR}/element-empty/tc_element-empty.rb"
require "#{INPUTDIR}/structures/tc_structures.rb"
#require "#{INPUTDIR}/element-empty/tc_element-ref.rb"

#EOF
