#!/usr/bin/env ruby

$VERBOSE = true

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../../lib'

require 'test/unit'
require 'xmlobj/RIFCS'

class RIFCS_XML_party_TestCase < Test::Unit::TestCase

  INPUTDIR = File.expand_path(File.dirname(__FILE__))

  def test_01
    file = File.new("#{INPUTDIR}/input-01.xml")
    doc, name = RIFCS.parse(file)

    assert_equal 'registryObjects', name
    assert_equal 1, doc.registryObject.length
    assert_not_nil doc.registryObject[0]
    assert_nil doc.registryObject[1]

    ro = doc.registryObject[0]
    assert_equal 'test-key', ro.key
    assert_equal 'http://example.com', ro.originatingSource._value
    assert_nil ro.originatingSource.type_attribute
    assert_not_nil ro.choice
    assert_equal :party, ro.choice._option

    party = ro.choice[:party]
    assert_not_nil ro.choice[:party]

    # Attributes

    assert_equal 'party-type', party.type_attribute
    assert_nil party.dateModified
    assert_not_nil party._choices

    assert_equal 0, party._choices.length # no data elements in this party record

  end

  def test_02
    file = File.new("#{INPUTDIR}/input-02-name.xml")
    doc, name = RIFCS.parse(file)

    party = doc.registryObject[0].choice[:party]
    assert_not_nil party

    assert_equal 1, party._choices.length
    assert_equal :name, party._choices[0]._option
    assert_equal 1, party._choices[0].name.length
    name = party._choices[0].name[0]

    assert_equal 'primary', name.type_attribute
    assert_nil name.dateFrom
    assert_nil name.dateTo
    assert_nil name.lang
    assert_not_nil name.namePart

    assert_equal 1, name.namePart.length

    assert_nil name.namePart[0].type_attribute
    assert_equal 'John Smith', name.namePart[0]._value

    # Second party record

    party = doc.registryObject[1].choice[:party]
    assert_not_nil party

    assert_equal 1, party._choices.length
    assert_equal :name, party._choices[0]._option
    assert_equal 1, party._choices[0].name.length
    name = party._choices[0].name[0]

    assert_equal 'primary', name.type_attribute
    assert_nil name.dateFrom
    assert_nil name.dateTo
    assert_nil name.lang
    assert_not_nil name.namePart

    assert_equal 3, name.namePart.length

    assert_equal 'given', name.namePart[0].type_attribute
    assert_equal 'John', name.namePart[0]._value

    assert_equal 'initial', name.namePart[1].type_attribute
    assert_equal 'J', name.namePart[1]._value

    assert_equal 'family', name.namePart[2].type_attribute
    assert_equal 'Citizen', name.namePart[2]._value

    # Third party record

    party = doc.registryObject[2].choice[:party]
    assert_not_nil party

    assert_equal 1, party._choices.length # choice has 1 option
    assert_equal :name, party._choices[0]._option

    array_of_names = party._choices[0].name
    assert_equal 3, array_of_names.length # the option is three names

    name1 = array_of_names[0]
    assert_equal 'primary', name1.type_attribute

    name2 = array_of_names[1]
    assert_equal 'abbreviated', name2.type_attribute

    name3 = array_of_names[2]
    assert_equal 'alternative', name3.type_attribute

  end
end

#EOF
