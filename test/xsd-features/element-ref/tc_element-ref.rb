#!/usr/bin/env ruby

$VERBOSE = true

require 'test/unit'
require 'xsd-features/ElementRef.rb'

class ElementEmptyTestCase < Test::Unit::TestCase

  def test01
    file = File.new('test/xsd-features/element-ref/test-01.xml')
    doc, name = ElementEmpty.parse(file)

    assert_equal 'book', name
  end

end

#EOF
