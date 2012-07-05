#!/usr/bin/env ruby

$VERBOSE = true

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../../lib'

require 'test/unit'
require 'xmlobj/xsd-features/AttributeGroup.rb'

class AttributeGroupTestCase < Test::Unit::TestCase

  INPUTDIR = File.expand_path(File.dirname(__FILE__))

  def test01
    file = File.new("#{INPUTDIR}/input-01.xml")
    doc, name = AttributeGroup.parse(file)

    assert_equal 'root', name
    assert_equal 'abc', doc.foo
    assert_nil doc.bar
  end

  def test02
    file = File.new("#{INPUTDIR}/input-02.xml")
    doc, name = AttributeGroup.parse(file)

    assert_equal 'root', name
    assert_equal 'abc', doc.foo
    assert_equal 'def', doc.bar
  end
end

#EOF
