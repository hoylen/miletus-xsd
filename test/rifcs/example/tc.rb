#!/usr/bin/env ruby

$VERBOSE = true

require 'test/unit'
require 'xmlobj/RIFCS'

class RIFCS_example_TestCase < Test::Unit::TestCase

  DIR = global_variables.include?(:$input_dir) ? eval('$input_dir') : ''

  def test_01
    file = File.new("#{DIR}input-01.xml")
    doc, name = RIFCS.parse(file)

    assert_equal 'registryObjects', name
    assert_equal 3, doc.registryObject.length
  end

  def test_02
    file = File.new("#{DIR}input-02.xml")
    doc, name = RIFCS.parse(file)

    assert_equal 'registryObjects', name
    assert_equal 4, doc.registryObject.length
  end
end

#EOF
