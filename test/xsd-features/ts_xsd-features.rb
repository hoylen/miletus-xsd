#!/usr/bin/env ruby
# XSD features test suite.

$VERBOSE = true

# Include all the XSD features test cases

require 'xsd-features/attributeGroup/tc_attributeGroup.rb'
require 'xsd-features/element-empty/tc_element-empty.rb'
require 'xsd-features/structures/tc_structures.rb'
#require 'test/xsd-features/element-empty/tc_element-ref.rb'

#EOF
