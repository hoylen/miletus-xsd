#!/usr/bin/env ruby

$VERBOSE = true

require 'test/unit'
require 'xmlobj/RIFCS'

class RIFCS_registryObjects_TestCase < Test::Unit::TestCase

  DIR = global_variables.include?(:$input_dir) ? eval('$input_dir') : ''

  def load(filename)
    file = File.new(filename)
    RIFCS.parse(file)
  end

  def test_01
    doc, name = load("#{DIR}input-01.xml")

    assert_equal 'registryObjects', name
    assert_equal 0, doc.registryObject.length
    assert_nil doc.registryObject[0]
  end

  def test_02
    doc, name = load("#{DIR}input-02.xml")

    assert_equal 'registryObjects', name
    assert_equal 1, doc.registryObject.length
    ro = doc.registryObject[0]
    assert_not_nil ro

    assert_equal 'test-group', ro.group
    assert_equal 'test-key', ro.key
    assert_equal 'http://example.com', ro.originatingSource._value
    assert_nil ro.originatingSource.type_attribute

    # The choice is a collection

    assert_equal :collection, ro.choice._option
    assert_nil ro.choice.party
    assert_nil ro.choice.activity
    assert_nil ro.choice.service
    assert_not_nil ro.choice.collection

    # Check the collection (only the mandatory 'type' attribute is present)

    c = ro.choice.collection

    assert_equal 'test-collection-type', c.type_attribute
    assert_nil c.dateModified
    assert_nil c.dateAccessioned

    assert_equal 0, c._choices.length # no data elements in this collection

    # No other registryObject should be present

    assert_nil doc.registryObject[1]
  end

  def test_03
    doc, name = load("#{DIR}input-03.xml")

    assert_equal 'registryObjects', name
    assert_equal 4, doc.registryObject.length
    ro = doc.registryObject[0]
    assert_not_nil ro

    # Collection

    assert_equal 'test-group', ro.group
    assert_equal 'test-key-1', ro.key
    assert_equal 'http://example.com', ro.originatingSource._value
    assert_equal 'originating-source-type', ro.originatingSource.type_attribute

    assert_equal :collection, ro.choice._option
    assert_not_nil ro.choice.collection
    assert_nil ro.choice.party
    assert_nil ro.choice.activity
    assert_nil ro.choice.service

    # Check the collection (all optional attributes are present)

    c = ro.choice.collection

    assert_equal 'test-collection-type', c.type_attribute
    assert_equal '2012-06-01', c.dateModified
    assert_equal '2012-06-01', c.dateAccessioned

    assert_equal 0, c._choices.length # no data elements in this collection

    # Party

    ro = doc.registryObject[1]
    assert_not_nil ro

    assert_equal :party, ro.choice._option
    assert_nil ro.choice.collection
    assert_not_nil ro.choice.party
    assert_nil ro.choice.activity
    assert_nil ro.choice.service

    # Activity

    ro = doc.registryObject[2]
    assert_not_nil ro

    assert_equal :activity, ro.choice._option
    assert_nil ro.choice.collection
    assert_nil ro.choice.party
    assert_not_nil ro.choice.activity
    assert_nil ro.choice.service

    # Service

    ro = doc.registryObject[3]
    assert_not_nil ro

    assert_equal :service, ro.choice._option
    assert_nil ro.choice.collection
    assert_nil ro.choice.party
    assert_nil ro.choice.activity
    assert_not_nil ro.choice.service

    # No more registryObject elements

    assert_nil doc.registryObject[4]
  end

  def test_04
    assert_raise(RIFCS::InvalidXMLError) { load("#{DIR}input-04-invalid-no-group.xml") }
  end

  def test_05
    assert_raise(RIFCS::InvalidXMLError) { load("#{DIR}input-05-invalid-no-key.xml") }
  end

  def test_06
    assert_raise(RIFCS::InvalidXMLError) { load("#{DIR}input-06-invalid-no-originatingSource.xml") }
  end

  def test_07
    assert_raise(RIFCS::InvalidXMLError) { load("#{DIR}input-07-invalid-missing-collection.xml") }
  end

  def test_08
    assert_raise(RIFCS::InvalidXMLError) { load("#{DIR}input-08-unexpected.xml") }
  end

end

#EOF
