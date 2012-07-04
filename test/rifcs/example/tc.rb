#!/usr/bin/env ruby

$VERBOSE = true

require 'test/unit'
require 'xmlobj/RIFCS'

class RIFCS_example_TestCase < Test::Unit::TestCase

  INPUTDIR = File.expand_path(File.dirname(__FILE__))

  def test_01
    file = File.new("#{INPUTDIR}/input-01.xml")
    doc, name = RIFCS.parse(file)

    assert_equal 'registryObjects', name
    assert_equal 3, doc.registryObject.length
  end

  def test_02
    file = File.new("#{INPUTDIR}/input-02.xml")
    doc, name = RIFCS.parse(file)

    assert_equal 'registryObjects', name
    assert_equal 4, doc.registryObject.length
  end
end

#EOF
