#!/usr/bin/ruby -w

require 'test/unit'
require 'xsd-features/ElementEmpty.rb'

class ElementEmptyTestCase < Test::Unit::TestCase

  def test01
    file = File.new('test/xsd-features/element-empty/test-01.xml')
    doc, name = ElementEmpty.parse(file)

    assert_equal 'root', name
  end

  def test02
    file = File.new('test/xsd-features/element-empty/test-02.xml')
    doc, name = ElementEmpty.parse(file)

    assert_equal 'root', name
  end

  def test03
    file = File.new('test/xsd-features/element-empty/test-03.xml')
    doc, name = ElementEmpty.parse(file)

    assert_equal 'root', name
  end

  def test04
    file = File.new('test/xsd-features/element-empty/test-04.xml')
    doc, name = ElementEmpty.parse(file)

    assert_equal 'root', name
  end

  def test05
    file = File.new('test/xsd-features/element-empty/test-05.xml')
    assert_raise(ElementEmpty::InvalidXMLError) { ElementEmpty.parse(file) }
  end
end

#EOF
