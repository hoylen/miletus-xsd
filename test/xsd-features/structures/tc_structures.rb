#!/usr/bin/env ruby

$VERBOSE = true

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../../lib'

require 'test/unit'
require 'xmlobj/xsd-features/Structures.rb'

class StructuresTestCase < Test::Unit::TestCase

  INPUTDIR = File.expand_path(File.dirname(__FILE__))

  def test01
    file = File.new("#{INPUTDIR}/input-01.xml")
    doc, name = Structures.parse(file)

    assert_equal 'element_with_sequence', name
    assert_not_nil doc.mandatory1
    assert_equal 'Alpha', doc.mandatory1

    assert_not_nil doc.mandatory2
    assert_equal 'Beta', doc.mandatory2

    assert_not_nil doc.mandatory3
    assert_equal 'Gamma', doc.mandatory3

    assert_not_nil doc.mandatory4
    assert_equal 'Delta', doc.mandatory4

    assert_nil doc.optional1 # this optional element is not present
    assert_nil doc.optional2 # this optional element is not present

  end

  def test02
    file = File.new("#{INPUTDIR}/input-02.xml")
    doc, name = Structures.parse(file)

    # Check character entities are expanded correctly

    assert_equal 'element_with_sequence', name
    assert_equal 'Ampersand &', doc.mandatory1
    assert_equal 'Less than sign <', doc.mandatory2
    assert_equal 'Greater than sign >', doc.mandatory3
    assert_equal 'Multiples & & & > > < < & & &', doc.mandatory4
    assert_equal 'attribute & < > " \' &', doc.attr3
  end

  def test03
    file = File.new("#{INPUTDIR}/input-03.xml")
    doc, name = Structures.parse(file)

    assert_equal 'element_with_choice', name
    assert_equal 'Alpha', doc.option1
  end
end

#EOF
