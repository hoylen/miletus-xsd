#!/usr/bin/env ruby

$VERBOSE = true

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../../lib'

require 'test/unit'
require 'xmlobj/xsd-features/ElementRef.rb'

class ElementRefTestCase < Test::Unit::TestCase

  INPUTDIR = File.expand_path(File.dirname(__FILE__))

  def test01
    file = File.new("#{INPUTDIR}/input-01.xml")
    doc, name = ElementRef.parse(file)

    assert_equal 'book', name
    assert_not_nil doc
  end

end

#EOF
