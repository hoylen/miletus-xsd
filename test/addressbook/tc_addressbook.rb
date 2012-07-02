#!/usr/bin/env ruby

$VERBOSE = true

require 'test/unit'
require 'xmlobj/AddressBook.rb'

class Test1 < Test::Unit::TestCase
  def test1
    file = File.new('test/addressbook/input-01.xml')
    doc, element_name = AddressBook.parse(file)

    assert_equal 'person', element_name

    assert_equal 'John Smith', doc.name
    assert_equal 1, doc.phone.length

    assert_equal 'home', doc.phone[0].type_attribute
    assert_equal '+61 7 1234 5678', doc.phone[0]._value

    assert_nil doc.phone[1]
  end

end

#EOF
