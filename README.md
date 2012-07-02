miletus-xsd
===========

RIF-CS XML parser in Ruby

Introduction
------------

This is a parser for parsing RIF-CS in Ruby. The parser takes
takes in the XML parsed by REXML, performs schema validation
on it, and produces objects to represent the data.

Usage
-----

An XML document is parsed into an object that can easily be
walked by code. The methods on that object match the names of the
attribute and content model of the XML document as much as possible.

### Simple elements

Elements are represented by a method with the same name as the element.

    <person id="24601">
      <name>John Citizen</name>
      <email>john@example.com</name>
      <dob>1970-01-01</dob>
    </person>

    person.id
    person.name
    person.email
    person.dob

If the element is non-repeatable (i.e. `maxOccurs` is 1) the method
returns an object representing it, or `nil` if the element is not
present.

If the element is repeatable (i.e. `maxOccurs` is greater than one or
is unbounded) the method always returns an array. If the element
is not present, an empty array is returned.

### Attributes

Attributes are represented by a method with the same name as the attribute.
If the attribute is not present, the value will be `nil`.

### Repeating elements

Repeating element are represented as Ruby Arrays.

    person.email is an array


    email.type
    email._value


References
----------

ECMAScript for XML (E4X), 2nd edition (December 2005).
http://www.ecma-international.org/publications/standards/Ecma-357.htm

This interface is similar to the E4X-style API. This article describes
a Ruby prototype of that API, but it is dynamic rather than based on
XML Schema. The interesting thing about the E4X-style API is that you
can parse XML fragments into an object.
http://onlamp.com/onlamp/2004/08/12/ruby_e4x.html
