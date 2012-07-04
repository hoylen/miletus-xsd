#!/usr/bin/env ruby

$VERBOSE = true

require 'test/unit'
require 'xsd-features/ElementRef.rb'

class ElementEmptyTestCase < Test::Unit::TestCase

  INPUTDIR = File.expand_path(File.dirname(__FILE__))

  def test01
    file = File.new("#{INPUTDIR}/input-01.xml")
    doc, name = ElementEmpty.parse(file)

    assert_equal 'book', name
  end

end

#EOF
