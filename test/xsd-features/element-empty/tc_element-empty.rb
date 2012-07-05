#!/usr/bin/env ruby

$VERBOSE = true

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../../lib'

require 'test/unit'
require 'xmlobj/xsd-features/ElementEmpty.rb'

class ElementEmptyTestCase < Test::Unit::TestCase

  INPUTDIR = File.expand_path(File.dirname(__FILE__))

  def test01
    file = File.new("#{INPUTDIR}/input-01.xml")
    doc, name = ElementEmpty.parse(file)

    assert_equal 'root', name
    assert_not_nil doc
  end

  def test02
    file = File.new("#{INPUTDIR}/input-02.xml")
    doc, name = ElementEmpty.parse(file)

    assert_equal 'root', name
    assert_not_nil doc
  end

  def test03
    file = File.new("#{INPUTDIR}/input-03.xml")
    doc, name = ElementEmpty.parse(file)

    assert_equal 'root', name
    assert_not_nil doc
  end

  def test04
    file = File.new("#{INPUTDIR}/input-04.xml")
    doc, name = ElementEmpty.parse(file)

    assert_equal 'root', name
    assert_not_nil doc
  end

  def test05
    file = File.new("#{INPUTDIR}/input-05.xml")
    assert_raise(ElementEmpty::InvalidXMLError) { ElementEmpty.parse(file) }
  end
end

#EOF
