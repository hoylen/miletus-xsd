#!/usr/bin/env ruby

$VERBOSE = true

require 'test/unit'
require 'xmlobj/xsd-features/AttributeGroup.rb'

class AttributeGroupTestCase < Test::Unit::TestCase

  def test01
    file = File.new('test/xsd-features/attributeGroup/test-01.xml')
    doc, name = AttributeGroup.parse(file)

    assert_equal 'root', name
    assert_equal 'abc', doc.foo
    assert_nil doc.bar
  end

  def test02
    file = File.new('test/xsd-features/attributeGroup/test-02.xml')
    doc, name = AttributeGroup.parse(file)

    assert_equal 'root', name
    assert_equal 'abc', doc.foo
    assert_equal 'def', doc.bar
  end
end

#EOF
