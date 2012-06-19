#!/usr/bin/ruby -w

require 'test/unit'
require 'rifcs.rb'

class RIFCS_example_TestCase < Test::Unit::TestCase

  def test_01
    file = File.new('test/rifcs/example/test-01.xml')
    doc, name = RIFCS.parse(file)

    assert_equal 'registryObjects', name
    assert_equal 3, doc.registryObject.length
  end

  def test_02
    file = File.new('test/rifcs/example/test-02.xml')
    doc, name = RIFCS.parse(file)

    assert_equal 'registryObjects', name
    assert_equal 4, doc.registryObject.length
  end
end

#EOF
