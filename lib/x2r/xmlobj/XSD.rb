#!/usr/bin/env ruby
#
# :title: XSD: objects for XML namespace http://www.w3.org/2001/XMLSchema
#
# = XSD
#
# This module defines classes to represent an XML infoset
# for the XML namespace:
#
#   http://www.w3.org/2001/XMLSchema
#
# It also defines methods to parse an XML document into those
# objects and to serialize those objects into an XML document.
#
# Use the parse method to convert an XML document (from either
# a +File+ or a +String+) into objects.
#
# Invoke the +xml+ method on an object to serialize it into XML.
#
# == Methods to parse for elements
#
# <code>parse_ComplexType_schemaType</code>::
#   the <code>schema</code> element
#
# == Examples
#
# === Parsing for a specific element
#
#   file = File.new("example.xml")
#   doc = REXML::Document.new(file)
#   root_node = doc.root
#   root_element = XSDparse_ComplexType_schemaType(root_node) # parsing for the schema element
#
# === Parsing for any element declared at the top level
#
#   file = File.new("example.xml")
#   doc = REXML::Document.new(file)
#   obj, name = XSD.parser(doc.root)
#   if name != 'expectedRootElementName'
#     ... # root element matched some other element
#   end
#
#   src.xml($stdout)
#
# === Error handling
#
#   begin
#     elem = XSDparse_ComplexType_schemaType(root_node)
#   rescue InvalidXMLError => e
#     ... # schema validity error
#   rescue REXML:...
#     ... # well-formed XML error
#   end
#--
# GENERATED CODE: DO NOT EDIT

require 'rexml/document'
require 'xmlobj/XSDPrimitives'

module XSD

#----------------------------------------------------------------

# Target XML namespace this module represents.
NAMESPACE='http://www.w3.org/2001/XMLSchema'

#----------------------------------------------------------------

class Base
  # The REXML::node from which this object was parsed,
  # or +nil+ if this object was not parsed from XML.
  #
  attr_accessor :xml_src_node

  # Constructor.
  # The +node+ is the REXML::node that provides the
  # namespace context for interpreting any QNames.
  # The +node+ can be +nil+, but then +expand_qname+ cannot be invoked
  # (which is fine for some objects where QNames are not used).
  #
  def initialize(node)
    @xml_src_node = node
  end

  # Gets the namespace name and local part of a QName (XML qualified
  # name) from a lexical representation of that QName. The lexical
  # representation consists an optional prefix followed by a colon,
  # followed by the local part. The prefix is mapped into the
  # namespace name according to the namespace declarations of the
  # current XML node. If there is no prefix, then the default namespace
  # is the namespace name of the QName.
  #
  # For example, if this object represents the following element,
  # this method can be used to expand the two attribute values.
  #
  #   <myelement xmlns="http://ns.example.com/def/1.0"
  #              xmlns:foo="http://ns.example.com/foo/1.0"
  #              myqname1="foo:bar"
  #              myqname2="baz"/>
  #
  #   expand_qname("foo:bar" => [ "http://ns.example.com/foo/1.0", "bar" ]
  #   expand_qname("baz" => [ "http://ns.example.com/def/1.0", "baz" ]

  def expand_qname(qname)
    a, b = qname.split(':')
    if b
      # a=prefix; b=localname
      ns = @xml_src_node.namespace(a)
      localname = b
    else
      # a=localname (in current namespace)
      ns = @xml_src_node.namespace('')
      localname = a
    end
    if ! ns
      if b && a == 'xml'
        ns = 'http://www.w3.org/XML/1998/namespace'
      else
        raise "unknown namespace for QName "#{qname}""
      end
    end
    [ ns, localname ]

  end
end

#----------------

# Class to represent the complexType: <code>annotationType</code>.
#
class ComplexType_annotationType < Base
  # The <code></code> attribute.
  attr_accessor :lang
  # An instance of <code>Sequence_in_ComplexType_annotationType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>documentation</code> element.  An array of <code>ComplexType_documentationType</code>. Can be an empty array.
  def documentation; @_sequence.documentation end
  # Sets the child <code>documentation</code> element.  An array of <code>ComplexType_documentationType</code>. Can be an empty array.
  def documentation=(value); @_sequence.documentation(value) end

  def initialize(node)
    super(node)
    # Attribute
    @lang = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if lang
        io.print " =\""
        io.print XSDPrimitives.pcdata(@lang)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_annotationType < Base
  # An array of [0..*] <code>ComplexType_documentationType</code> objects.
  attr_accessor :documentation
  def initialize(node)
    super(node)
    @documentation = []
  end
  def to_xml(inscope_ns, indent, io)
    @documentation.each do |i|
      i.to_xml(XSD::NAMESPACE, 'documentation', inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent the complexType: <code>attributeGroupType</code>.
#
class ComplexType_attributeGroupType < Base
  # The <code>name</code> attribute.
  attr_accessor :name
  # The <code>ref</code> attribute.
  attr_accessor :ref
  # An instance of <code>Sequence_in_ComplexType_attributeGroupType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation; @_sequence.annotation end
  # Sets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation=(value); @_sequence.annotation(value) end

  # Gets the child <code>choice</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_attributeGroupType</code>. Can be an empty array.
  def choice; @_sequence.choice end
  # Sets the child <code>choice</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_attributeGroupType</code>. Can be an empty array.
  def choice=(value); @_sequence.choice(value) end

  def initialize(node)
    super(node)
    # Attribute
    @name = nil
    # Attribute
    @ref = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if name
        io.print " name=\""
        io.print XSDPrimitives.pcdata(@name)
        io.print '"'
      end
      if ref
        io.print " ref=\""
        io.print XSDPrimitives.pcdata(@ref)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_attributeGroupType < Base
  # An array of [0..*] <code>ComplexType_annotationType</code> objects.
  attr_accessor :annotation
  # An array of [0..*] <code>Choice_in_Sequence_in_ComplexType_attributeGroupType</code> objects.
  attr_accessor :choice
  def initialize(node)
    super(node)
    @annotation = []
    @choice = []
  end
  def to_xml(inscope_ns, indent, io)
    @annotation.each do |i|
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
    choice.each do |i|
      i.to_xml(inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent a choice.
#
# The choice's option can be determined by the _option method, which
# will return one of the symbols in the NAMES array. The value of
# that option can be obtained by calling [] with that symbol or the
# method with the same name as the symbol. Only one option of the
# choice will be chosen: attempting to obtain the values of any
# other option will return +nil+.
#
class Choice_in_Sequence_in_ComplexType_attributeGroupType < Base
  # Names for the options in this choice.
  NAMES = [ :attribute, :attributeGroup,]

  def initialize(node)

    super(node)
    @_index = nil # indicates which option (0..1 or nil)
    @_value = nil # the value of the option
  end

  # Indexed accessors

  # Returns a symbol indicating which option for the choice. Result is one of
  # the symbols from +NAME+, or +nil+ if no option has been set.
  def _option
    @_index != nil ? NAMES[@_index] : nil
  end

  # Set the choice to the option identified by +symbol+ and to have the +value+.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def []=(symbol, value)
    match = NAMES.index(symbol)
    if match
      @_index = match
      @_value = value
    else
      raise IndexError, "choice has no option: #{symbol}"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    (match == @_index) ? @_value : nil
  end

  # Named accessors

  # Get the value of option +attribute+.
# Returns an array of <code>ComplexType_attributeType</code> objects.
# Returns +nil+ if not the option.
  def attribute
    (0 == @_index) ? @_value : nil
  end
  # Set the choice to be the +attribute+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_attributeType</code> objects.
  def attribute=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +attributeGroup+.
# Returns an array of <code>ComplexType_attributeGroupType</code> objects.
# Returns +nil+ if not the option.
  def attributeGroup
    (1 == @_index) ? @_value : nil
  end
  # Set the choice to be the +attributeGroup+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_attributeGroupType</code> objects.
  def attributeGroup=(value)
    @_index = 1
    @_value = value
  end

def to_xml(inscope_ns, indent, io)
  case @_index
  when 0
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'attribute', inscope_ns, indent, io)
    end
  when 1
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'attributeGroup', inscope_ns, indent, io)
    end
  end
end
end

#----------------

# Class to represent the complexType: <code>attributeType</code>.
#
class ComplexType_attributeType < Base
  # The <code>name</code> attribute.
  attr_accessor :name
  # The <code>type</code> attribute.
  attr_accessor :type_attribute
  # The <code>ref</code> attribute.
  attr_accessor :ref
  # The <code>use</code> attribute.
  attr_accessor :use
  # An instance of <code>Sequence_in_ComplexType_attributeType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation; @_sequence.annotation end
  # Sets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation=(value); @_sequence.annotation(value) end

  # Gets the child <code>simpleType</code> element.  A single <code>ComplexType_simpleTypeType</code>. Optional element, so could be +nil+.
  def simpleType; @_sequence.simpleType end
  # Sets the child <code>simpleType</code> element.  A single <code>ComplexType_simpleTypeType</code>. Optional element, so could be +nil+.
  def simpleType=(value); @_sequence.simpleType(value) end

  def initialize(node)
    super(node)
    # Attribute
    @name = nil
    # Attribute
    @type_attribute = nil
    # Attribute
    @ref = nil
    # Attribute
    @use = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if name
        io.print " name=\""
        io.print XSDPrimitives.pcdata(@name)
        io.print '"'
      end
      if type_attribute
        io.print " type=\""
        io.print XSDPrimitives.pcdata(@type_attribute)
        io.print '"'
      end
      if ref
        io.print " ref=\""
        io.print XSDPrimitives.pcdata(@ref)
        io.print '"'
      end
      if use
        io.print " use=\""
        io.print XSDPrimitives.pcdata(@use)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_attributeType < Base
  # An array of [0..*] <code>ComplexType_annotationType</code> objects.
  attr_accessor :annotation
  # An instance of <code>ComplexType_simpleTypeType</code> (optional element, can be +nil+).
  attr_accessor :simpleType
  def initialize(node)
    super(node)
    @annotation = []
    @simpleType = nil
  end
  def to_xml(inscope_ns, indent, io)
    @annotation.each do |i|
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
    m = @simpleType
    if m
      m.to_xml(XSD::NAMESPACE, 'simpleType', inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent the complexType: <code>choiceType</code>.
#
class ComplexType_choiceType < Base
  # The <code>minOccurs</code> attribute.
  attr_accessor :minOccurs
  # The <code>maxOccurs</code> attribute.
  attr_accessor :maxOccurs
  # An instance of <code>Sequence_in_ComplexType_choiceType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation; @_sequence.annotation end
  # Sets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation=(value); @_sequence.annotation(value) end

  # Gets the child <code>choice</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_choiceType</code>. Has a minimum length of #{member.choice.minOccurs}.
  def choice; @_sequence.choice end
  # Sets the child <code>choice</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_choiceType</code>. Has a minimum length of #{member.choice.minOccurs}.
  def choice=(value); @_sequence.choice(value) end

  def initialize(node)
    super(node)
    # Attribute
    @minOccurs = nil
    # Attribute
    @maxOccurs = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if minOccurs
        io.print " minOccurs=\""
        io.print XSDPrimitives.pcdata(@minOccurs)
        io.print '"'
      end
      if maxOccurs
        io.print " maxOccurs=\""
        io.print XSDPrimitives.pcdata(@maxOccurs)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_choiceType < Base
  # An array of [0..*] <code>ComplexType_annotationType</code> objects.
  attr_accessor :annotation
  # An array of [1..*] <code>Choice_in_Sequence_in_ComplexType_choiceType</code> objects.
  attr_accessor :choice
  def initialize(node)
    super(node)
    @annotation = []
    @choice = []
  end
  def to_xml(inscope_ns, indent, io)
    @annotation.each do |i|
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
    choice.each do |i|
      i.to_xml(inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent a choice.
#
# The choice's option can be determined by the _option method, which
# will return one of the symbols in the NAMES array. The value of
# that option can be obtained by calling [] with that symbol or the
# method with the same name as the symbol. Only one option of the
# choice will be chosen: attempting to obtain the values of any
# other option will return +nil+.
#
class Choice_in_Sequence_in_ComplexType_choiceType < Base
  # Names for the options in this choice.
  NAMES = [ :element, :sequence, :choice,]

  def initialize(node)

    super(node)
    @_index = nil # indicates which option (0..2 or nil)
    @_value = nil # the value of the option
  end

  # Indexed accessors

  # Returns a symbol indicating which option for the choice. Result is one of
  # the symbols from +NAME+, or +nil+ if no option has been set.
  def _option
    @_index != nil ? NAMES[@_index] : nil
  end

  # Set the choice to the option identified by +symbol+ and to have the +value+.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def []=(symbol, value)
    match = NAMES.index(symbol)
    if match
      @_index = match
      @_value = value
    else
      raise IndexError, "choice has no option: #{symbol}"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    (match == @_index) ? @_value : nil
  end

  # Named accessors

  # Get the value of option +element+.
# Returns an array of <code>ComplexType_elementType</code> objects.
# Returns +nil+ if not the option.
  def element
    (0 == @_index) ? @_value : nil
  end
  # Set the choice to be the +element+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_elementType</code> objects.
  def element=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +sequence+.
# Returns an array of <code>ComplexType_sequenceType</code> objects.
# Returns +nil+ if not the option.
  def sequence
    (1 == @_index) ? @_value : nil
  end
  # Set the choice to be the +sequence+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_sequenceType</code> objects.
  def sequence=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +choice+.
# Returns an array of <code>ComplexType_choiceType</code> objects.
# Returns +nil+ if not the option.
  def choice
    (2 == @_index) ? @_value : nil
  end
  # Set the choice to be the +choice+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_choiceType</code> objects.
  def choice=(value)
    @_index = 2
    @_value = value
  end

def to_xml(inscope_ns, indent, io)
  case @_index
  when 0
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'element', inscope_ns, indent, io)
    end
  when 1
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'sequence', inscope_ns, indent, io)
    end
  when 2
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'choice', inscope_ns, indent, io)
    end
  end
end
end

#----------------

# Class to represent the complexType: <code>complexTypeType</code>.
#
class ComplexType_complexTypeType < Base
  # The <code>name</code> attribute.
  attr_accessor :name
  # An instance of <code>Sequence_in_ComplexType_complexTypeType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation; @_sequence.annotation end
  # Sets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation=(value); @_sequence.annotation(value) end

  # Gets the child <code>choice1</code>.  A single <code>Choice_in_Sequence_in_ComplexType_complexTypeType</code>. Optional, so could be +nil+.
  def choice1; @_sequence.choice1 end
  # Sets the child <code>choice1</code>.  A single <code>Choice_in_Sequence_in_ComplexType_complexTypeType</code>. Optional, so could be +nil+.
  def choice1=(value); @_sequence.choice1(value) end

  # Gets the child <code>choice2</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_complexTypeType1</code>. Can be an empty array.
  def choice2; @_sequence.choice2 end
  # Sets the child <code>choice2</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_complexTypeType1</code>. Can be an empty array.
  def choice2=(value); @_sequence.choice2(value) end

  def initialize(node)
    super(node)
    # Attribute
    @name = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if name
        io.print " name=\""
        io.print XSDPrimitives.pcdata(@name)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_complexTypeType < Base
  # An array of [0..*] <code>ComplexType_annotationType</code> objects.
  attr_accessor :annotation
  # An instance of <code>Choice_in_Sequence_in_ComplexType_complexTypeType</code> (optional choice, can be +nil+).
  attr_accessor :choice1
  # An array of [0..*] <code>Choice_in_Sequence_in_ComplexType_complexTypeType1</code> objects.
  attr_accessor :choice2
  def initialize(node)
    super(node)
    @annotation = []
    @choice1 = nil
    @choice2 = []
  end
  def to_xml(inscope_ns, indent, io)
    @annotation.each do |i|
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
    m =  choice1
    if m
      m.to_xml(inscope_ns, indent, io)
    end
    choice2.each do |i|
      i.to_xml(inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent a choice.
#
# The choice's option can be determined by the _option method, which
# will return one of the symbols in the NAMES array. The value of
# that option can be obtained by calling [] with that symbol or the
# method with the same name as the symbol. Only one option of the
# choice will be chosen: attempting to obtain the values of any
# other option will return +nil+.
#
class Choice_in_Sequence_in_ComplexType_complexTypeType < Base
  # Names for the options in this choice.
  NAMES = [ :simpleContent, :sequence, :choice,]

  def initialize(node)

    super(node)
    @_index = nil # indicates which option (0..2 or nil)
    @_value = nil # the value of the option
  end

  # Indexed accessors

  # Returns a symbol indicating which option for the choice. Result is one of
  # the symbols from +NAME+, or +nil+ if no option has been set.
  def _option
    @_index != nil ? NAMES[@_index] : nil
  end

  # Set the choice to the option identified by +symbol+ and to have the +value+.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def []=(symbol, value)
    match = NAMES.index(symbol)
    if match
      @_index = match
      @_value = value
    else
      raise IndexError, "choice has no option: #{symbol}"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    (match == @_index) ? @_value : nil
  end

  # Named accessors

  # Get the value of option +simpleContent+.
# Returns an array of <code>ComplexType_simpleContentType</code> objects.
# Returns +nil+ if not the option.
  def simpleContent
    (0 == @_index) ? @_value : nil
  end
  # Set the choice to be the +simpleContent+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_simpleContentType</code> objects.
  def simpleContent=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +sequence+.
# Returns an array of <code>ComplexType_sequenceType</code> objects.
# Returns +nil+ if not the option.
  def sequence
    (1 == @_index) ? @_value : nil
  end
  # Set the choice to be the +sequence+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_sequenceType</code> objects.
  def sequence=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +choice+.
# Returns an array of <code>ComplexType_choiceType</code> objects.
# Returns +nil+ if not the option.
  def choice
    (2 == @_index) ? @_value : nil
  end
  # Set the choice to be the +choice+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_choiceType</code> objects.
  def choice=(value)
    @_index = 2
    @_value = value
  end

def to_xml(inscope_ns, indent, io)
  case @_index
  when 0
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'simpleContent', inscope_ns, indent, io)
    end
  when 1
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'sequence', inscope_ns, indent, io)
    end
  when 2
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'choice', inscope_ns, indent, io)
    end
  end
end
end

#----------------

# Class to represent a choice.
#
# The choice's option can be determined by the _option method, which
# will return one of the symbols in the NAMES array. The value of
# that option can be obtained by calling [] with that symbol or the
# method with the same name as the symbol. Only one option of the
# choice will be chosen: attempting to obtain the values of any
# other option will return +nil+.
#
class Choice_in_Sequence_in_ComplexType_complexTypeType1 < Base
  # Names for the options in this choice.
  NAMES = [ :attribute, :attributeGroup,]

  def initialize(node)

    super(node)
    @_index = nil # indicates which option (0..1 or nil)
    @_value = nil # the value of the option
  end

  # Indexed accessors

  # Returns a symbol indicating which option for the choice. Result is one of
  # the symbols from +NAME+, or +nil+ if no option has been set.
  def _option
    @_index != nil ? NAMES[@_index] : nil
  end

  # Set the choice to the option identified by +symbol+ and to have the +value+.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def []=(symbol, value)
    match = NAMES.index(symbol)
    if match
      @_index = match
      @_value = value
    else
      raise IndexError, "choice has no option: #{symbol}"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    (match == @_index) ? @_value : nil
  end

  # Named accessors

  # Get the value of option +attribute+.
# Returns an array of <code>ComplexType_attributeType</code> objects.
# Returns +nil+ if not the option.
  def attribute
    (0 == @_index) ? @_value : nil
  end
  # Set the choice to be the +attribute+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_attributeType</code> objects.
  def attribute=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +attributeGroup+.
# Returns an array of <code>ComplexType_attributeGroupType</code> objects.
# Returns +nil+ if not the option.
  def attributeGroup
    (1 == @_index) ? @_value : nil
  end
  # Set the choice to be the +attributeGroup+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_attributeGroupType</code> objects.
  def attributeGroup=(value)
    @_index = 1
    @_value = value
  end

def to_xml(inscope_ns, indent, io)
  case @_index
  when 0
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'attribute', inscope_ns, indent, io)
    end
  when 1
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'attributeGroup', inscope_ns, indent, io)
    end
  end
end
end

#----------------

# Class to represent the complexType: <code>documentationType</code>.
#
class ComplexType_documentationType < Base
  # The <code>source</code> attribute.
  attr_accessor :source # attribute from extension
  # The <code></code> attribute.
  attr_accessor :lang # attribute from extension

  # The simpleContent value as a +String+.
  # In XML Schema, this is an extension of <code>xsd:string</code>.
  attr_accessor :_value

  def initialize(node)
    super(node)
    @source = nil
    @lang = nil

    @_value = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if @source
        io.print ' source="'
        io.print XSDPrimitives.pcdata(@source)
        io.print '"'
      end
      if @lang
        io.print ' ="'
        io.print XSDPrimitives.pcdata(@lang)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      if @_value
        io.print XSDPrimitives.cdata(@_value)
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent the complexType: <code>elementType</code>.
#
class ComplexType_elementType < Base
  # The <code>name</code> attribute.
  attr_accessor :name
  # The <code>type</code> attribute.
  attr_accessor :type_attribute
  # The <code>minOccurs</code> attribute.
  attr_accessor :minOccurs
  # The <code>maxOccurs</code> attribute.
  attr_accessor :maxOccurs
  # The <code>ref</code> attribute.
  attr_accessor :ref
  # An instance of <code>Sequence_in_ComplexType_elementType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation; @_sequence.annotation end
  # Sets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation=(value); @_sequence.annotation(value) end

  # Gets the child <code>choice</code>.  A single <code>Choice_in_Sequence_in_ComplexType_elementType</code>. Optional, so could be +nil+.
  def choice; @_sequence.choice end
  # Sets the child <code>choice</code>.  A single <code>Choice_in_Sequence_in_ComplexType_elementType</code>. Optional, so could be +nil+.
  def choice=(value); @_sequence.choice(value) end

  def initialize(node)
    super(node)
    # Attribute
    @name = nil
    # Attribute
    @type_attribute = nil
    # Attribute
    @minOccurs = nil
    # Attribute
    @maxOccurs = nil
    # Attribute
    @ref = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if name
        io.print " name=\""
        io.print XSDPrimitives.pcdata(@name)
        io.print '"'
      end
      if type_attribute
        io.print " type=\""
        io.print XSDPrimitives.pcdata(@type_attribute)
        io.print '"'
      end
      if minOccurs
        io.print " minOccurs=\""
        io.print XSDPrimitives.pcdata(@minOccurs)
        io.print '"'
      end
      if maxOccurs
        io.print " maxOccurs=\""
        io.print XSDPrimitives.pcdata(@maxOccurs)
        io.print '"'
      end
      if ref
        io.print " ref=\""
        io.print XSDPrimitives.pcdata(@ref)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_elementType < Base
  # An array of [0..*] <code>ComplexType_annotationType</code> objects.
  attr_accessor :annotation
  # An instance of <code>Choice_in_Sequence_in_ComplexType_elementType</code> (optional choice, can be +nil+).
  attr_accessor :choice
  def initialize(node)
    super(node)
    @annotation = []
    @choice = nil
  end
  def to_xml(inscope_ns, indent, io)
    @annotation.each do |i|
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
    m =  choice
    if m
      m.to_xml(inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent a choice.
#
# The choice's option can be determined by the _option method, which
# will return one of the symbols in the NAMES array. The value of
# that option can be obtained by calling [] with that symbol or the
# method with the same name as the symbol. Only one option of the
# choice will be chosen: attempting to obtain the values of any
# other option will return +nil+.
#
class Choice_in_Sequence_in_ComplexType_elementType < Base
  # Names for the options in this choice.
  NAMES = [ :complexType,]

  def initialize(node)

    super(node)
    @_index = nil # indicates which option (0..0 or nil)
    @_value = nil # the value of the option
  end

  # Indexed accessors

  # Returns a symbol indicating which option for the choice. Result is one of
  # the symbols from +NAME+, or +nil+ if no option has been set.
  def _option
    @_index != nil ? NAMES[@_index] : nil
  end

  # Set the choice to the option identified by +symbol+ and to have the +value+.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def []=(symbol, value)
    match = NAMES.index(symbol)
    if match
      @_index = match
      @_value = value
    else
      raise IndexError, "choice has no option: #{symbol}"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    (match == @_index) ? @_value : nil
  end

  # Named accessors

  # Get the value of option +complexType+.
# Returns an array of <code>ComplexType_complexTypeType</code> objects.
# Returns +nil+ if not the option.
  def complexType
    (0 == @_index) ? @_value : nil
  end
  # Set the choice to be the +complexType+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_complexTypeType</code> objects.
  def complexType=(value)
    @_index = 0
    @_value = value
  end

def to_xml(inscope_ns, indent, io)
  case @_index
  when 0
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'complexType', inscope_ns, indent, io)
    end
  end
end
end

#----------------

# Class to represent the complexType: <code>enumerationType</code>.
#
class ComplexType_enumerationType < Base
  # The <code>value</code> attribute.
  attr_accessor :value # attribute from extension

  # The simpleContent value as a +String+.
  # In XML Schema, this is an extension of <code>xsd:string</code>.
  attr_accessor :_value

  def initialize(node)
    super(node)
    @value = nil

    @_value = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if @value
        io.print ' value="'
        io.print XSDPrimitives.pcdata(@value)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      if @_value
        io.print XSDPrimitives.cdata(@_value)
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent the complexType: <code>extensionType</code>.
#
class ComplexType_extensionType < Base
  # The <code>base</code> attribute.
  attr_accessor :base
  # An instance of <code>Sequence_in_ComplexType_extensionType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>attribute</code> element.  An array of <code>ComplexType_attributeType</code>. Has a minimum length of #{member.element.minOccurs}.
  def attribute; @_sequence.attribute end
  # Sets the child <code>attribute</code> element.  An array of <code>ComplexType_attributeType</code>. Has a minimum length of #{member.element.minOccurs}.
  def attribute=(value); @_sequence.attribute(value) end

  # Gets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation; @_sequence.annotation end
  # Sets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation=(value); @_sequence.annotation(value) end

  def initialize(node)
    super(node)
    # Attribute
    @base = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if base
        io.print " base=\""
        io.print XSDPrimitives.pcdata(@base)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_extensionType < Base
  # An array of [1..*] <code>ComplexType_attributeType</code> objects.
  attr_accessor :attribute
  # An array of [0..*] <code>ComplexType_annotationType</code> objects.
  attr_accessor :annotation
  def initialize(node)
    super(node)
    @attribute = []
    @annotation = []
  end
  def to_xml(inscope_ns, indent, io)
    @attribute.each do |i|
      i.to_xml(XSD::NAMESPACE, 'attribute', inscope_ns, indent, io)
    end
    @annotation.each do |i|
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent the complexType: <code>importType</code>.
#
class ComplexType_importType < Base
  # The <code>namespace</code> attribute.
  attr_accessor :namespace
  # The <code>schemaLocation</code> attribute.
  attr_accessor :schemaLocation
  def initialize(node)
    super(node)
    # Attribute
    @namespace = nil
    # Attribute
    @schemaLocation = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if namespace
        io.print " namespace=\""
        io.print XSDPrimitives.pcdata(@namespace)
        io.print '"'
      end
      if schemaLocation
        io.print " schemaLocation=\""
        io.print XSDPrimitives.pcdata(@schemaLocation)
        io.print '"'
      end
      io.print '/>'
      io.puts
    end
end

#----------------

# Class to represent the complexType: <code>includeType</code>.
#
class ComplexType_includeType < Base
  # The <code>schemaLocation</code> attribute.
  attr_accessor :schemaLocation
  def initialize(node)
    super(node)
    # Attribute
    @schemaLocation = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if schemaLocation
        io.print " schemaLocation=\""
        io.print XSDPrimitives.pcdata(@schemaLocation)
        io.print '"'
      end
      io.print '/>'
      io.puts
    end
end

#----------------

# Class to represent the complexType: <code>restrictionType</code>.
#
class ComplexType_restrictionType < Base
  # The <code>base</code> attribute.
  attr_accessor :base
  # An instance of <code>Sequence_in_ComplexType_restrictionType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>enumeration</code> element.  An array of <code>ComplexType_enumerationType</code>. Can be an empty array.
  def enumeration; @_sequence.enumeration end
  # Sets the child <code>enumeration</code> element.  An array of <code>ComplexType_enumerationType</code>. Can be an empty array.
  def enumeration=(value); @_sequence.enumeration(value) end

  def initialize(node)
    super(node)
    # Attribute
    @base = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if base
        io.print " base=\""
        io.print XSDPrimitives.pcdata(@base)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_restrictionType < Base
  # An array of [0..*] <code>ComplexType_enumerationType</code> objects.
  attr_accessor :enumeration
  def initialize(node)
    super(node)
    @enumeration = []
  end
  def to_xml(inscope_ns, indent, io)
    @enumeration.each do |i|
      i.to_xml(XSD::NAMESPACE, 'enumeration', inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent the complexType: <code>schemaType</code>.
#
class ComplexType_schemaType < Base
  # The <code>version</code> attribute.
  attr_accessor :version
  # The <code>targetNamespace</code> attribute.
  attr_accessor :targetNamespace
  # The <code>elementFormDefault</code> attribute.
  attr_accessor :elementFormDefault
  # The <code>attributeFormDefault</code> attribute.
  attr_accessor :attributeFormDefault
  # The <code></code> attribute.
  attr_accessor :lang
  # An instance of <code>Sequence_in_ComplexType_schemaType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>choice1</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_schemaType</code>. Can be an empty array.
  def choice1; @_sequence.choice1 end
  # Sets the child <code>choice1</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_schemaType</code>. Can be an empty array.
  def choice1=(value); @_sequence.choice1(value) end

  # Gets the child <code>choice2</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_schemaType1</code>. Can be an empty array.
  def choice2; @_sequence.choice2 end
  # Sets the child <code>choice2</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_schemaType1</code>. Can be an empty array.
  def choice2=(value); @_sequence.choice2(value) end

  def initialize(node)
    super(node)
    # Attribute
    @version = nil
    # Attribute
    @targetNamespace = nil
    # Attribute
    @elementFormDefault = nil
    # Attribute
    @attributeFormDefault = nil
    # Attribute
    @lang = nil
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      if version
        io.print " version=\""
        io.print XSDPrimitives.pcdata(@version)
        io.print '"'
      end
      if targetNamespace
        io.print " targetNamespace=\""
        io.print XSDPrimitives.pcdata(@targetNamespace)
        io.print '"'
      end
      if elementFormDefault
        io.print " elementFormDefault=\""
        io.print XSDPrimitives.pcdata(@elementFormDefault)
        io.print '"'
      end
      if attributeFormDefault
        io.print " attributeFormDefault=\""
        io.print XSDPrimitives.pcdata(@attributeFormDefault)
        io.print '"'
      end
      if lang
        io.print " =\""
        io.print XSDPrimitives.pcdata(@lang)
        io.print '"'
      end
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_schemaType < Base
  # An array of [0..*] <code>Choice_in_Sequence_in_ComplexType_schemaType</code> objects.
  attr_accessor :choice1
  # An array of [0..*] <code>Choice_in_Sequence_in_ComplexType_schemaType1</code> objects.
  attr_accessor :choice2
  def initialize(node)
    super(node)
    @choice1 = []
    @choice2 = []
  end
  def to_xml(inscope_ns, indent, io)
    choice1.each do |i|
      i.to_xml(inscope_ns, indent, io)
    end
    choice2.each do |i|
      i.to_xml(inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent a choice.
#
# The choice's option can be determined by the _option method, which
# will return one of the symbols in the NAMES array. The value of
# that option can be obtained by calling [] with that symbol or the
# method with the same name as the symbol. Only one option of the
# choice will be chosen: attempting to obtain the values of any
# other option will return +nil+.
#
class Choice_in_Sequence_in_ComplexType_schemaType < Base
  # Names for the options in this choice.
  NAMES = [ :annotation, :include, :import,]

  def initialize(node)

    super(node)
    @_index = nil # indicates which option (0..2 or nil)
    @_value = nil # the value of the option
  end

  # Indexed accessors

  # Returns a symbol indicating which option for the choice. Result is one of
  # the symbols from +NAME+, or +nil+ if no option has been set.
  def _option
    @_index != nil ? NAMES[@_index] : nil
  end

  # Set the choice to the option identified by +symbol+ and to have the +value+.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def []=(symbol, value)
    match = NAMES.index(symbol)
    if match
      @_index = match
      @_value = value
    else
      raise IndexError, "choice has no option: #{symbol}"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    (match == @_index) ? @_value : nil
  end

  # Named accessors

  # Get the value of option +annotation+.
# Returns an array of <code>ComplexType_annotationType</code> objects.
# Returns +nil+ if not the option.
  def annotation
    (0 == @_index) ? @_value : nil
  end
  # Set the choice to be the +annotation+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_annotationType</code> objects.
  def annotation=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +include+.
# Returns an array of <code>ComplexType_includeType</code> objects.
# Returns +nil+ if not the option.
  def include
    (1 == @_index) ? @_value : nil
  end
  # Set the choice to be the +include+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_includeType</code> objects.
  def include=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +import+.
# Returns an array of <code>ComplexType_importType</code> objects.
# Returns +nil+ if not the option.
  def import
    (2 == @_index) ? @_value : nil
  end
  # Set the choice to be the +import+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_importType</code> objects.
  def import=(value)
    @_index = 2
    @_value = value
  end

def to_xml(inscope_ns, indent, io)
  case @_index
  when 0
    @_value.each do |i|
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
  when 1
    @_value.each do |i|
      i.to_xml(XSD::NAMESPACE, 'include', inscope_ns, indent, io)
    end
  when 2
    @_value.each do |i|
      i.to_xml(XSD::NAMESPACE, 'import', inscope_ns, indent, io)
    end
  end
end
end

#----------------

# Class to represent a choice.
#
# The choice's option can be determined by the _option method, which
# will return one of the symbols in the NAMES array. The value of
# that option can be obtained by calling [] with that symbol or the
# method with the same name as the symbol. Only one option of the
# choice will be chosen: attempting to obtain the values of any
# other option will return +nil+.
#
class Choice_in_Sequence_in_ComplexType_schemaType1 < Base
  # Names for the options in this choice.
  NAMES = [ :annotation, :element, :attribute, :simpleType, :complexType, :attributeGroup,]

  def initialize(node)

    super(node)
    @_index = nil # indicates which option (0..5 or nil)
    @_value = nil # the value of the option
  end

  # Indexed accessors

  # Returns a symbol indicating which option for the choice. Result is one of
  # the symbols from +NAME+, or +nil+ if no option has been set.
  def _option
    @_index != nil ? NAMES[@_index] : nil
  end

  # Set the choice to the option identified by +symbol+ and to have the +value+.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def []=(symbol, value)
    match = NAMES.index(symbol)
    if match
      @_index = match
      @_value = value
    else
      raise IndexError, "choice has no option: #{symbol}"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    (match == @_index) ? @_value : nil
  end

  # Named accessors

  # Get the value of option +annotation+.
# Returns an array of <code>ComplexType_annotationType</code> objects.
# Returns +nil+ if not the option.
  def annotation
    (0 == @_index) ? @_value : nil
  end
  # Set the choice to be the +annotation+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_annotationType</code> objects.
  def annotation=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +element+.
# Returns an array of <code>ComplexType_elementType</code> objects.
# Returns +nil+ if not the option.
  def element
    (1 == @_index) ? @_value : nil
  end
  # Set the choice to be the +element+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_elementType</code> objects.
  def element=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +attribute+.
# Returns an array of <code>ComplexType_attributeType</code> objects.
# Returns +nil+ if not the option.
  def attribute
    (2 == @_index) ? @_value : nil
  end
  # Set the choice to be the +attribute+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_attributeType</code> objects.
  def attribute=(value)
    @_index = 2
    @_value = value
  end

  # Get the value of option +simpleType+.
# Returns an array of <code>ComplexType_simpleTypeType</code> objects.
# Returns +nil+ if not the option.
  def simpleType
    (3 == @_index) ? @_value : nil
  end
  # Set the choice to be the +simpleType+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_simpleTypeType</code> objects.
  def simpleType=(value)
    @_index = 3
    @_value = value
  end

  # Get the value of option +complexType+.
# Returns an array of <code>ComplexType_complexTypeType</code> objects.
# Returns +nil+ if not the option.
  def complexType
    (4 == @_index) ? @_value : nil
  end
  # Set the choice to be the +complexType+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_complexTypeType</code> objects.
  def complexType=(value)
    @_index = 4
    @_value = value
  end

  # Get the value of option +attributeGroup+.
# Returns an array of <code>ComplexType_attributeGroupType</code> objects.
# Returns +nil+ if not the option.
  def attributeGroup
    (5 == @_index) ? @_value : nil
  end
  # Set the choice to be the +attributeGroup+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_attributeGroupType</code> objects.
  def attributeGroup=(value)
    @_index = 5
    @_value = value
  end

def to_xml(inscope_ns, indent, io)
  case @_index
  when 0
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
  when 1
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'element', inscope_ns, indent, io)
    end
  when 2
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'attribute', inscope_ns, indent, io)
    end
  when 3
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'simpleType', inscope_ns, indent, io)
    end
  when 4
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'complexType', inscope_ns, indent, io)
    end
  when 5
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'attributeGroup', inscope_ns, indent, io)
    end
  end
end
end

#----------------

# Class to represent the complexType: <code>sequenceType</code>.
#
class ComplexType_sequenceType < Base
  # An instance of <code>Sequence_in_ComplexType_sequenceType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation; @_sequence.annotation end
  # Sets the child <code>annotation</code> element.  An array of <code>ComplexType_annotationType</code>. Can be an empty array.
  def annotation=(value); @_sequence.annotation(value) end

  # Gets the child <code>choice</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_sequenceType</code>. Has a minimum length of #{member.choice.minOccurs}.
  def choice; @_sequence.choice end
  # Sets the child <code>choice</code>.  An array of <code>Choice_in_Sequence_in_ComplexType_sequenceType</code>. Has a minimum length of #{member.choice.minOccurs}.
  def choice=(value); @_sequence.choice(value) end

  def initialize(node)
    super(node)
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_sequenceType < Base
  # An array of [0..*] <code>ComplexType_annotationType</code> objects.
  attr_accessor :annotation
  # An array of [1..*] <code>Choice_in_Sequence_in_ComplexType_sequenceType</code> objects.
  attr_accessor :choice
  def initialize(node)
    super(node)
    @annotation = []
    @choice = []
  end
  def to_xml(inscope_ns, indent, io)
    @annotation.each do |i|
      i.to_xml(XSD::NAMESPACE, 'annotation', inscope_ns, indent, io)
    end
    choice.each do |i|
      i.to_xml(inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent a choice.
#
# The choice's option can be determined by the _option method, which
# will return one of the symbols in the NAMES array. The value of
# that option can be obtained by calling [] with that symbol or the
# method with the same name as the symbol. Only one option of the
# choice will be chosen: attempting to obtain the values of any
# other option will return +nil+.
#
class Choice_in_Sequence_in_ComplexType_sequenceType < Base
  # Names for the options in this choice.
  NAMES = [ :element, :sequence, :choice,]

  def initialize(node)

    super(node)
    @_index = nil # indicates which option (0..2 or nil)
    @_value = nil # the value of the option
  end

  # Indexed accessors

  # Returns a symbol indicating which option for the choice. Result is one of
  # the symbols from +NAME+, or +nil+ if no option has been set.
  def _option
    @_index != nil ? NAMES[@_index] : nil
  end

  # Set the choice to the option identified by +symbol+ and to have the +value+.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def []=(symbol, value)
    match = NAMES.index(symbol)
    if match
      @_index = match
      @_value = value
    else
      raise IndexError, "choice has no option: #{symbol}"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    (match == @_index) ? @_value : nil
  end

  # Named accessors

  # Get the value of option +element+.
# Returns an array of <code>ComplexType_elementType</code> objects.
# Returns +nil+ if not the option.
  def element
    (0 == @_index) ? @_value : nil
  end
  # Set the choice to be the +element+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_elementType</code> objects.
  def element=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +sequence+.
# Returns an array of <code>ComplexType_sequenceType</code> objects.
# Returns +nil+ if not the option.
  def sequence
    (1 == @_index) ? @_value : nil
  end
  # Set the choice to be the +sequence+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_sequenceType</code> objects.
  def sequence=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +choice+.
# Returns an array of <code>ComplexType_choiceType</code> objects.
# Returns +nil+ if not the option.
  def choice
    (2 == @_index) ? @_value : nil
  end
  # Set the choice to be the +choice+ option with the +value+.
  # The value needs to be an array of <code>ComplexType_choiceType</code> objects.
  def choice=(value)
    @_index = 2
    @_value = value
  end

def to_xml(inscope_ns, indent, io)
  case @_index
  when 0
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'element', inscope_ns, indent, io)
    end
  when 1
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'sequence', inscope_ns, indent, io)
    end
  when 2
    i =  @_value
    if i
      i.to_xml(XSD::NAMESPACE, 'choice', inscope_ns, indent, io)
    end
  end
end
end

#----------------

# Class to represent the complexType: <code>simpleContentType</code>.
#
class ComplexType_simpleContentType < Base
  # An instance of <code>Sequence_in_ComplexType_simpleContentType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>extension</code> element.  A single <code>ComplexType_extensionType</code>. Mandatory element, so is never +nil+.
  def extension; @_sequence.extension end
  # Sets the child <code>extension</code> element.  A single <code>ComplexType_extensionType</code>. Mandatory element, so is never +nil+.
  def extension=(value); @_sequence.extension(value) end

  def initialize(node)
    super(node)
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_simpleContentType < Base
  # An instance of <code>ComplexType_extensionType</code> (mandatory element, always has a non-nil value).
  attr_accessor :extension
  def initialize(node)
    super(node)
    @extension = nil
  end
  def to_xml(inscope_ns, indent, io)
    m = @extension
    if m
      m.to_xml(XSD::NAMESPACE, 'extension', inscope_ns, indent, io)
    end
  end
end

#----------------

# Class to represent the complexType: <code>simpleTypeType</code>.
#
class ComplexType_simpleTypeType < Base
  # An instance of <code>Sequence_in_ComplexType_simpleTypeType</code>
  # to represent the sequence which defines the content model
  # of this complexType. Users of this class will invoke
  # the methods of the sequence that have been replicated
  # by this class: they do not need to directly access the sequence.
  attr_accessor :_sequence

  # Since this is a complexType defined by a sequence,
  # the members of that sequence can be accessed through
  # the following getters and setters. They invoke the
  # corresponding method on the _sequence object, so
  # the user doesn't have to interact with the underlying
  # _sequence at all.

  # Gets the child <code>restriction</code> element.  A single <code>ComplexType_restrictionType</code>. Mandatory element, so is never +nil+.
  def restriction; @_sequence.restriction end
  # Sets the child <code>restriction</code> element.  A single <code>ComplexType_restrictionType</code>. Mandatory element, so is never +nil+.
  def restriction=(value); @_sequence.restriction(value) end

  def initialize(node)
    super(node)
    @_sequence = nil
  end

    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#{p}=\"#{element_namespace}\""
        else
          ns_def = " xmlns=\"#{element_namespace}\""
        end
      end
      if prefix
        qualifier = "#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#{qualifier}#{element_name}#{ns_def}"
      io.print '>'

      if indent
        nested_indent = indent + '  '
      else
        nested_indent = nil
      end
      io.puts
      _sequence.to_xml(new_inscope_ns, nested_indent, io)
      if indent
        io.print indent
      end
      io.print "</#{qualifier}#{element_name}>"
      if indent
        io.puts
      end
    end
end

#----------------

# Class to represent a sequence.
#
class Sequence_in_ComplexType_simpleTypeType < Base
  # An instance of <code>ComplexType_restrictionType</code> (mandatory element, always has a non-nil value).
  attr_accessor :restriction
  def initialize(node)
    super(node)
    @restriction = nil
  end
  def to_xml(inscope_ns, indent, io)
    m = @restriction
    if m
      m.to_xml(XSD::NAMESPACE, 'restriction', inscope_ns, indent, io)
    end
  end
end

  #----------------------------------------------------------------

  # Exception raised when parsing XML and it violates the XML Schema.
  #
  class InvalidXMLError < Exception; end

  #----------------------------------------------------------------
  # Methods used to parse XML

  private

  # Parses the element +node+ for an optional attribute of the given
  # +name+. If the attribute is present, its value (as a +String+) is
  # returned, otherwise +nil+ is returned.

  def self.attr_optional(node, name)
    a = node.attribute(name)
    a ? a.value : nil
  end

  # Parses the element +node+ for a required attribute of the given
  # +name+. If the attribute is present, its value (as a +String+) is
  # returned, otherwise an exception is raised.
  def self.attr_required(node, name)
    a = node.attribute(name)
    if ! a
      raise InvalidXMLError, "mandatory attribute missing: #{name}"
    end
    a.value
  end

  # Parses an empty element. Such elements contain no attributes
  # and no content model.
  def self.parse_element_empty(node)
      # TODO: check for no attributes

      node.each_child do |child|
      if child.is_a?(REXML::Element)
        raise InvalidXMLError, "unexpected element in empty content model: {#{child.namespace}}#{child.name}"
      elsif child.is_a?(REXML::Text)
        expecting_whitespace child
      elsif child.is_a?(REXML::Comment)
        # Ignore comments
      else
        raise InvalidXMLError, "unknown node type: #{child.class}"
      end
    end

  end

  # Checks if the +node+ contains just whitespace text. Assumes that
  # the +node+ is a +REXML::Text+ object. Raises an exception there are
  # non-whitespace characters in the text.
  #
  def self.expecting_whitespace(node)
    if node.to_s !~ /^ *$/
      raise InvalidXMLError, "Unexpected text: #{node.to_s.strip}"
    end
  end

  # Skip nodes until the first element
  #
  def self.skip_to_element(nodes, offset)
    while offset < nodes.length do
      node = nodes[offset]
      if node.is_a?(REXML::Element)
        return offset
      elsif node.is_a?(REXML::Text)
        expecting_whitespace node
        offset += 1
      elsif node.is_a?(REXML::Comment)
        # Ignore comments
        offset += 1
      else
        raise InvalidXMLError, "Unknown node type: #{node.class}"
      end
    end
    offset
  end

#----------------------------------------------------------------
# Parsing methods

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_annotationType(nodes, offset)

  result = Sequence_in_ComplexType_annotationType.new(nil)


  # 1: element: documentation

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'documentation' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_documentationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.documentation = r


  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_annotationType</code>

def self.parse_ComplexType_annotationType(node)

  # Create result object
  result = XSD::ComplexType_annotationType.new(node)

    result.lang = attr_optional(node, '')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_annotationType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_annotationType: #{node.children[offset].name}"
  end

  # Success
  result
end

private
# Parser for choice: <code>Choice_in_Sequence_in_ComplexType_attributeGroupType</code>
#
# Returns an array of [0..*] Choice_in_Sequence_in_ComplexType_attributeGroupType objects, since this choice has been defined with a maxOccurs greater than 1 (or unbounded).

def self.parse_Choice_in_Sequence_in_ComplexType_attributeGroupType(nodes, offset)

  results = []
  reason = ": not enough elements"

  while offset < nodes.length
    # Move offset to next element node

    offset = skip_to_element(nodes, offset)
    if offset < nodes.length

      # Match element to one of the choice options

      node = nodes[offset]

      r = XSD::Choice_in_Sequence_in_ComplexType_attributeGroupType.new(node)

      if node.name == 'attribute' && node.namespace == NAMESPACE
        r.attribute = parse_ComplexType_attributeType(node)
        offset += 1
      elsif node.name == 'attributeGroup' && node.namespace == NAMESPACE
        r.attributeGroup = parse_ComplexType_attributeGroupType(node)
        offset += 1
      else
        reason = ": unexpected element: {#{node.namespace}}#{node.name}"
        break # element does not match any option
      end

      results << r
    end
  end

  return [ results, offset ]
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_attributeGroupType(nodes, offset)

  result = Sequence_in_ComplexType_attributeGroupType.new(nil)


  # 1: element: annotation

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_annotationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.annotation = r


  # 2: choice: choice

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'attribute' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'attributeGroup' && nodes[offset].namespace == NAMESPACE
      r, offset = parse_Choice_in_Sequence_in_ComplexType_attributeGroupType(nodes, offset)
      result.choice = r
    end
  end


  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_attributeGroupType</code>

def self.parse_ComplexType_attributeGroupType(node)

  # Create result object
  result = XSD::ComplexType_attributeGroupType.new(node)

    result.name = attr_optional(node, 'name')
    result.ref = attr_optional(node, 'ref')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_attributeGroupType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_attributeGroupType: #{node.children[offset].name}"
  end

  # Success
  result
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_attributeType(nodes, offset)

  result = Sequence_in_ComplexType_attributeType.new(nil)


  # 1: element: annotation

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_annotationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.annotation = r


  # 2: element: simpleType

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'simpleType' && nodes[offset].namespace == NAMESPACE
      r = parse_ComplexType_simpleTypeType(nodes[offset])
      offset += 1
    end
  end
  result.simpleType = r


  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_attributeType</code>

def self.parse_ComplexType_attributeType(node)

  # Create result object
  result = XSD::ComplexType_attributeType.new(node)

    result.name = attr_optional(node, 'name')
    result.type_attribute = attr_optional(node, 'type')
    result.ref = attr_optional(node, 'ref')
    result.use = attr_optional(node, 'use')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_attributeType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_attributeType: #{node.children[offset].name}"
  end

  # Success
  result
end

private
# Parser for choice: <code>Choice_in_Sequence_in_ComplexType_choiceType</code>
#
# Returns an array of [1..*] Choice_in_Sequence_in_ComplexType_choiceType objects, since this choice has been defined with a maxOccurs greater than 1 (or unbounded).

def self.parse_Choice_in_Sequence_in_ComplexType_choiceType(nodes, offset)

  results = []
  reason = ": not enough elements"

  while offset < nodes.length
    # Move offset to next element node

    offset = skip_to_element(nodes, offset)
    if offset < nodes.length

      # Match element to one of the choice options

      node = nodes[offset]

      r = XSD::Choice_in_Sequence_in_ComplexType_choiceType.new(node)

      if node.name == 'element' && node.namespace == NAMESPACE
        r.element = parse_ComplexType_elementType(node)
        offset += 1
      elsif node.name == 'sequence' && node.namespace == NAMESPACE
        r.sequence = parse_ComplexType_sequenceType(node)
        offset += 1
      elsif node.name == 'choice' && node.namespace == NAMESPACE
        r.choice = parse_ComplexType_choiceType(node)
        offset += 1
      else
        reason = ": unexpected element: {#{node.namespace}}#{node.name}"
        break # element does not match any option
      end

      results << r
    end
  end

  if results.length < 1
    raise InvalidXMLError, "choice incomplete#{reason}"
  end

  return [ results, offset ]
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_choiceType(nodes, offset)

  result = Sequence_in_ComplexType_choiceType.new(nil)


  # 1: element: annotation

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_annotationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.annotation = r


  # 2: choice: choice

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'element' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'sequence' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'choice' && nodes[offset].namespace == NAMESPACE
      r, offset = parse_Choice_in_Sequence_in_ComplexType_choiceType(nodes, offset)
      result.choice = r
    end
  end

  # Completeness check

  if result.choice.length < 1
    raise InvalidXMLError, "incomplete sequence"
  end

  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_choiceType</code>

def self.parse_ComplexType_choiceType(node)

  # Create result object
  result = XSD::ComplexType_choiceType.new(node)

    result.minOccurs = attr_optional(node, 'minOccurs')
    result.maxOccurs = attr_optional(node, 'maxOccurs')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_choiceType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_choiceType: #{node.children[offset].name}"
  end

  # Success
  result
end

private
# Parser for choice: <code>Choice_in_Sequence_in_ComplexType_complexTypeType</code>
#
# Returns either a Choice_in_Sequence_in_ComplexType_complexTypeType object or +nil+.

def self.parse_Choice_in_Sequence_in_ComplexType_complexTypeType(nodes, offset)

  reason = ": element not found"

  begin
    # Move offset to next element node

    offset = skip_to_element(nodes, offset)
    if offset < nodes.length

      # Match element to one of the choice options

      node = nodes[offset]
  result = XSD::Choice_in_Sequence_in_ComplexType_complexTypeType.new(nodes[offset])

      if node.name == 'simpleContent' && node.namespace == NAMESPACE
        result.simpleContent = parse_ComplexType_simpleContentType(node)
        offset += 1
      elsif node.name == 'sequence' && node.namespace == NAMESPACE
        result.sequence = parse_ComplexType_sequenceType(node)
        offset += 1
      elsif node.name == 'choice' && node.namespace == NAMESPACE
        result.choice = parse_ComplexType_choiceType(node)
        offset += 1
      else
        reason = ": unexpected element: {#{node.namespace}}#{node.name}"
      end
    end
  end

  if result._option
    return [ result, offset ]
  else
    return [ nil, offset ] # no match
  end
end

private
# Parser for choice: <code>Choice_in_Sequence_in_ComplexType_complexTypeType1</code>
#
# Returns an array of [0..*] Choice_in_Sequence_in_ComplexType_complexTypeType1 objects, since this choice has been defined with a maxOccurs greater than 1 (or unbounded).

def self.parse_Choice_in_Sequence_in_ComplexType_complexTypeType1(nodes, offset)

  results = []
  reason = ": not enough elements"

  while offset < nodes.length
    # Move offset to next element node

    offset = skip_to_element(nodes, offset)
    if offset < nodes.length

      # Match element to one of the choice options

      node = nodes[offset]

      r = XSD::Choice_in_Sequence_in_ComplexType_complexTypeType1.new(node)

      if node.name == 'attribute' && node.namespace == NAMESPACE
        r.attribute = parse_ComplexType_attributeType(node)
        offset += 1
      elsif node.name == 'attributeGroup' && node.namespace == NAMESPACE
        r.attributeGroup = parse_ComplexType_attributeGroupType(node)
        offset += 1
      else
        reason = ": unexpected element: {#{node.namespace}}#{node.name}"
        break # element does not match any option
      end

      results << r
    end
  end

  return [ results, offset ]
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_complexTypeType(nodes, offset)

  result = Sequence_in_ComplexType_complexTypeType.new(nil)


  # 1: element: annotation

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_annotationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.annotation = r


  # 2: choice: choice1

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'simpleContent' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'sequence' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'choice' && nodes[offset].namespace == NAMESPACE
      r, offset = parse_Choice_in_Sequence_in_ComplexType_complexTypeType(nodes, offset)
      result.choice1 = r
    end
  end


  # 3: choice: choice2

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'attribute' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'attributeGroup' && nodes[offset].namespace == NAMESPACE
      r, offset = parse_Choice_in_Sequence_in_ComplexType_complexTypeType1(nodes, offset)
      result.choice2 = r
    end
  end


  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_complexTypeType</code>

def self.parse_ComplexType_complexTypeType(node)

  # Create result object
  result = XSD::ComplexType_complexTypeType.new(node)

    result.name = attr_optional(node, 'name')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_complexTypeType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_complexTypeType: #{node.children[offset].name}"
  end

  # Success
  result
end

public

# Parser for complexType: <code>ComplexType_documentationType</code>

def self.parse_ComplexType_documentationType(node)

  # Create result object
  result = XSD::ComplexType_documentationType.new(node)

  # Content model
  begin # extension parsing
    # Parse extension's attributes
    result.source = attr_optional(node, 'source')
    result.lang = attr_optional(node, '')
    # Parse extension's base
    result._value = XSDPrimitives.parse_string(node)
  end

  # Success
  result
end

private
# Parser for choice: <code>Choice_in_Sequence_in_ComplexType_elementType</code>
#
# Returns either a Choice_in_Sequence_in_ComplexType_elementType object or +nil+.

def self.parse_Choice_in_Sequence_in_ComplexType_elementType(nodes, offset)

  reason = ": element not found"

  begin
    # Move offset to next element node

    offset = skip_to_element(nodes, offset)
    if offset < nodes.length

      # Match element to one of the choice options

      node = nodes[offset]
  result = XSD::Choice_in_Sequence_in_ComplexType_elementType.new(nodes[offset])

      if node.name == 'complexType' && node.namespace == NAMESPACE
        result.complexType = parse_ComplexType_complexTypeType(node)
        offset += 1
      else
        reason = ": unexpected element: {#{node.namespace}}#{node.name}"
      end
    end
  end

  if result._option
    return [ result, offset ]
  else
    return [ nil, offset ] # no match
  end
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_elementType(nodes, offset)

  result = Sequence_in_ComplexType_elementType.new(nil)


  # 1: element: annotation

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_annotationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.annotation = r


  # 2: choice: choice

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'complexType' && nodes[offset].namespace == NAMESPACE
      r, offset = parse_Choice_in_Sequence_in_ComplexType_elementType(nodes, offset)
      result.choice = r
    end
  end


  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_elementType</code>

def self.parse_ComplexType_elementType(node)

  # Create result object
  result = XSD::ComplexType_elementType.new(node)

    result.name = attr_optional(node, 'name')
    result.type_attribute = attr_optional(node, 'type')
    result.minOccurs = attr_optional(node, 'minOccurs')
    result.maxOccurs = attr_optional(node, 'maxOccurs')
    result.ref = attr_optional(node, 'ref')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_elementType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_elementType: #{node.children[offset].name}"
  end

  # Success
  result
end

public

# Parser for complexType: <code>ComplexType_enumerationType</code>

def self.parse_ComplexType_enumerationType(node)

  # Create result object
  result = XSD::ComplexType_enumerationType.new(node)

  # Content model
  begin # extension parsing
    # Parse extension's attributes
    result.value = attr_optional(node, 'value')
    # Parse extension's base
    result._value = XSDPrimitives.parse_string(node)
  end

  # Success
  result
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_extensionType(nodes, offset)

  result = Sequence_in_ComplexType_extensionType.new(nil)


  # 1: element: attribute

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'attribute' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_attributeType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  if r.length < 1
    raise InvalidXMLError, "sequence not enough attribute elements"
  end
  result.attribute = r


  # 2: element: annotation

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_annotationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.annotation = r

  # Completeness check

  if result.attribute.length < 1
    raise InvalidXMLError, "incomplete sequence"
  end

  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_extensionType</code>

def self.parse_ComplexType_extensionType(node)

  # Create result object
  result = XSD::ComplexType_extensionType.new(node)

    result.base = attr_required(node, 'base')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_extensionType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_extensionType: #{node.children[offset].name}"
  end

  # Success
  result
end

public

# Parser for complexType: <code>ComplexType_importType</code>

def self.parse_ComplexType_importType(node)

  # Create result object
  result = XSD::ComplexType_importType.new(node)

    result.namespace = attr_required(node, 'namespace')
    result.schemaLocation = attr_optional(node, 'schemaLocation')
  # Content model
  # Empty content model: must only contain non-significant whitespace
  offset = 0
  while offset < node.children.length
    child = node.children[offset]
    if child.is_a?(REXML::Element)
      raise InvalidXMLError, "unexpected element in empty complexType"
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end

  # Success
  result
end

public

# Parser for complexType: <code>ComplexType_includeType</code>

def self.parse_ComplexType_includeType(node)

  # Create result object
  result = XSD::ComplexType_includeType.new(node)

    result.schemaLocation = attr_optional(node, 'schemaLocation')
  # Content model
  # Empty content model: must only contain non-significant whitespace
  offset = 0
  while offset < node.children.length
    child = node.children[offset]
    if child.is_a?(REXML::Element)
      raise InvalidXMLError, "unexpected element in empty complexType"
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end

  # Success
  result
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_restrictionType(nodes, offset)

  result = Sequence_in_ComplexType_restrictionType.new(nil)


  # 1: element: enumeration

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'enumeration' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_enumerationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.enumeration = r


  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_restrictionType</code>

def self.parse_ComplexType_restrictionType(node)

  # Create result object
  result = XSD::ComplexType_restrictionType.new(node)

    result.base = attr_optional(node, 'base')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_restrictionType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_restrictionType: #{node.children[offset].name}"
  end

  # Success
  result
end

private
# Parser for choice: <code>Choice_in_Sequence_in_ComplexType_schemaType</code>
#
# Returns an array of [0..*] Choice_in_Sequence_in_ComplexType_schemaType objects, since this choice has been defined with a maxOccurs greater than 1 (or unbounded).

def self.parse_Choice_in_Sequence_in_ComplexType_schemaType(nodes, offset)

  results = []
  reason = ": not enough elements"

  while offset < nodes.length
    # Move offset to next element node

    offset = skip_to_element(nodes, offset)
    if offset < nodes.length

      # Match element to one of the choice options

      node = nodes[offset]

      r = XSD::Choice_in_Sequence_in_ComplexType_schemaType.new(node)

      if node.name == 'annotation' && node.namespace == NAMESPACE
        r.annotation, offset = parse_Choice_in_Sequence_in_ComplexType_schemaType_element1(nodes, offset)
      elsif node.name == 'include' && node.namespace == NAMESPACE
        r.include, offset = parse_Choice_in_Sequence_in_ComplexType_schemaType_element2(nodes, offset)
      elsif node.name == 'import' && node.namespace == NAMESPACE
        r.import, offset = parse_Choice_in_Sequence_in_ComplexType_schemaType_element3(nodes, offset)
      else
        reason = ": unexpected element: {#{node.namespace}}#{node.name}"
        break # element does not match any option
      end

      results << r
    end
  end

  return [ results, offset ]
end

# Parser for repeating option's element 1 of choice: <code>Choice_in_Sequence_in_ComplexType_schemaType</code>
#
# This method must be called with the nodes[offset] being an element
# node that matches.

def self.parse_Choice_in_Sequence_in_ComplexType_schemaType_element1(nodes, offset)

  # Create result object

  results = []
  node = nodes[offset]
  while offset < nodes.length && node.name == 'annotation' && node.namespace == NAMESPACE
    results << parse_ComplexType_annotationType(node)
    offset += 1
    offset = skip_to_element(nodes, offset)
    node = nodes[offset]
  end

  raise 'internal error' if results.empty?
  [ results, offset ]
end

# Parser for repeating option's element 2 of choice: <code>Choice_in_Sequence_in_ComplexType_schemaType</code>
#
# This method must be called with the nodes[offset] being an element
# node that matches.

def self.parse_Choice_in_Sequence_in_ComplexType_schemaType_element2(nodes, offset)

  # Create result object

  results = []
  node = nodes[offset]
  while offset < nodes.length && node.name == 'include' && node.namespace == NAMESPACE
    results << parse_ComplexType_includeType(node)
    offset += 1
    offset = skip_to_element(nodes, offset)
    node = nodes[offset]
  end

  raise 'internal error' if results.empty?
  [ results, offset ]
end

# Parser for repeating option's element 3 of choice: <code>Choice_in_Sequence_in_ComplexType_schemaType</code>
#
# This method must be called with the nodes[offset] being an element
# node that matches.

def self.parse_Choice_in_Sequence_in_ComplexType_schemaType_element3(nodes, offset)

  # Create result object

  results = []
  node = nodes[offset]
  while offset < nodes.length && node.name == 'import' && node.namespace == NAMESPACE
    results << parse_ComplexType_importType(node)
    offset += 1
    offset = skip_to_element(nodes, offset)
    node = nodes[offset]
  end

  raise 'internal error' if results.empty?
  [ results, offset ]
end

private
# Parser for choice: <code>Choice_in_Sequence_in_ComplexType_schemaType1</code>
#
# Returns an array of [0..*] Choice_in_Sequence_in_ComplexType_schemaType1 objects, since this choice has been defined with a maxOccurs greater than 1 (or unbounded).

def self.parse_Choice_in_Sequence_in_ComplexType_schemaType1(nodes, offset)

  results = []
  reason = ": not enough elements"

  while offset < nodes.length
    # Move offset to next element node

    offset = skip_to_element(nodes, offset)
    if offset < nodes.length

      # Match element to one of the choice options

      node = nodes[offset]

      r = XSD::Choice_in_Sequence_in_ComplexType_schemaType1.new(node)

      if node.name == 'annotation' && node.namespace == NAMESPACE
        r.annotation = parse_ComplexType_annotationType(node)
        offset += 1
      elsif node.name == 'element' && node.namespace == NAMESPACE
        r.element = parse_ComplexType_elementType(node)
        offset += 1
      elsif node.name == 'attribute' && node.namespace == NAMESPACE
        r.attribute = parse_ComplexType_attributeType(node)
        offset += 1
      elsif node.name == 'simpleType' && node.namespace == NAMESPACE
        r.simpleType = parse_ComplexType_simpleTypeType(node)
        offset += 1
      elsif node.name == 'complexType' && node.namespace == NAMESPACE
        r.complexType = parse_ComplexType_complexTypeType(node)
        offset += 1
      elsif node.name == 'attributeGroup' && node.namespace == NAMESPACE
        r.attributeGroup = parse_ComplexType_attributeGroupType(node)
        offset += 1
      else
        reason = ": unexpected element: {#{node.namespace}}#{node.name}"
        break # element does not match any option
      end

      results << r
    end
  end

  return [ results, offset ]
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_schemaType(nodes, offset)

  result = Sequence_in_ComplexType_schemaType.new(nil)


  # 1: choice: choice1

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'include' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'import' && nodes[offset].namespace == NAMESPACE
      r, offset = parse_Choice_in_Sequence_in_ComplexType_schemaType(nodes, offset)
      result.choice1 = r
    end
  end


  # 2: choice: choice2

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'element' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'attribute' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'simpleType' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'complexType' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'attributeGroup' && nodes[offset].namespace == NAMESPACE
      r, offset = parse_Choice_in_Sequence_in_ComplexType_schemaType1(nodes, offset)
      result.choice2 = r
    end
  end


  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_schemaType</code>

def self.parse_ComplexType_schemaType(node)

  # Create result object
  result = XSD::ComplexType_schemaType.new(node)

    result.version = attr_optional(node, 'version')
    result.targetNamespace = attr_optional(node, 'targetNamespace')
    result.elementFormDefault = attr_optional(node, 'elementFormDefault')
    result.attributeFormDefault = attr_optional(node, 'attributeFormDefault')
    result.lang = attr_optional(node, '')
  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_schemaType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_schemaType: #{node.children[offset].name}"
  end

  # Success
  result
end

private
# Parser for choice: <code>Choice_in_Sequence_in_ComplexType_sequenceType</code>
#
# Returns an array of [1..*] Choice_in_Sequence_in_ComplexType_sequenceType objects, since this choice has been defined with a maxOccurs greater than 1 (or unbounded).

def self.parse_Choice_in_Sequence_in_ComplexType_sequenceType(nodes, offset)

  results = []
  reason = ": not enough elements"

  while offset < nodes.length
    # Move offset to next element node

    offset = skip_to_element(nodes, offset)
    if offset < nodes.length

      # Match element to one of the choice options

      node = nodes[offset]

      r = XSD::Choice_in_Sequence_in_ComplexType_sequenceType.new(node)

      if node.name == 'element' && node.namespace == NAMESPACE
        r.element = parse_ComplexType_elementType(node)
        offset += 1
      elsif node.name == 'sequence' && node.namespace == NAMESPACE
        r.sequence = parse_ComplexType_sequenceType(node)
        offset += 1
      elsif node.name == 'choice' && node.namespace == NAMESPACE
        r.choice = parse_ComplexType_choiceType(node)
        offset += 1
      else
        reason = ": unexpected element: {#{node.namespace}}#{node.name}"
        break # element does not match any option
      end

      results << r
    end
  end

  if results.length < 1
    raise InvalidXMLError, "choice incomplete#{reason}"
  end

  return [ results, offset ]
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_sequenceType(nodes, offset)

  result = Sequence_in_ComplexType_sequenceType.new(nil)


  # 1: element: annotation

  offset = skip_to_element(nodes, offset)

  r = []
  while offset < nodes.length &&
        nodes[offset].name == 'annotation' && nodes[offset].namespace == NAMESPACE
    r << parse_ComplexType_annotationType(nodes[offset])
    offset = skip_to_element(nodes, offset + 1)
  end
  result.annotation = r


  # 2: choice: choice

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'element' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'sequence' && nodes[offset].namespace == NAMESPACE || \
           nodes[offset].name == 'choice' && nodes[offset].namespace == NAMESPACE
      r, offset = parse_Choice_in_Sequence_in_ComplexType_sequenceType(nodes, offset)
      result.choice = r
    end
  end

  # Completeness check

  if result.choice.length < 1
    raise InvalidXMLError, "incomplete sequence"
  end

  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_sequenceType</code>

def self.parse_ComplexType_sequenceType(node)

  # Create result object
  result = XSD::ComplexType_sequenceType.new(node)

  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_sequenceType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_sequenceType: #{node.children[offset].name}"
  end

  # Success
  result
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_simpleContentType(nodes, offset)

  result = Sequence_in_ComplexType_simpleContentType.new(nil)


  # 1: element: extension

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'extension' && nodes[offset].namespace == NAMESPACE
      r = parse_ComplexType_extensionType(nodes[offset])
      offset += 1
    end
  end
  if ! r
    raise InvalidXMLError, "sequence missing 'extension': got '#{nodes[offset].name}'"
  end
  result.extension = r

  # Completeness check

  if ! result.extension
    raise InvalidXMLError, "incomplete sequence"
  end

  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_simpleContentType</code>

def self.parse_ComplexType_simpleContentType(node)

  # Create result object
  result = XSD::ComplexType_simpleContentType.new(node)

  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_simpleContentType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_simpleContentType: #{node.children[offset].name}"
  end

  # Success
  result
end

private
# Parser for a sequence.
#
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_Sequence_in_ComplexType_simpleTypeType(nodes, offset)

  result = Sequence_in_ComplexType_simpleTypeType.new(nil)


  # 1: element: restriction

  offset = skip_to_element(nodes, offset)

  r = nil
  if offset < nodes.length
    if nodes[offset].name == 'restriction' && nodes[offset].namespace == NAMESPACE
      r = parse_ComplexType_restrictionType(nodes[offset])
      offset += 1
    end
  end
  if ! r
    raise InvalidXMLError, "sequence missing 'restriction': got '#{nodes[offset].name}'"
  end
  result.restriction = r

  # Completeness check

  if ! result.restriction
    raise InvalidXMLError, "incomplete sequence"
  end

  return [result, offset]
end

public

# Parser for complexType: <code>ComplexType_simpleTypeType</code>

def self.parse_ComplexType_simpleTypeType(node)

  # Create result object
  result = XSD::ComplexType_simpleTypeType.new(node)

  # Content model
  result._sequence, offset = parse_Sequence_in_ComplexType_simpleTypeType(node.children, 0)
  offset = skip_to_element(node.children, offset)
  if offset < node.children.size
     raise InvalidXMLError, "complexType sequence has left over elements: ComplexType_simpleTypeType: #{node.children[offset].name}"
  end

  # Success
  result
end

public
# Parser for top level element +schema+
# Returns a <code>ComplexType_schemaType</code> object.
def self.parse_schema(element)
  if element.name == 'schema' && element.namespace == NAMESPACE
    parse_ComplexType_schemaType(element)
  else
    raise InvalidXMLError, "unexpected element: expecting {NAMESPACE}schema: got {#{element.namespace}}#{element.name}"
  end
end

  #----------------

  public

  # Parser for this module. Will parse the +src+ for
  # top level elements from the XML Schema or raise an
  # exception if none can be successfully parsed.
  #
  # An XML Schema does not indicate which element it expects to be the
  # root element of an XML document, and this method reflects that. If
  # the XML Schema declares only one top level element, then that is the
  # only element that can be successfully matched. But if multiple top
  # level elements are declared, then this method could successfully
  # match any one of them.  Unless the schema only defined one top level
  # element, the caller should check the returned element +name+ is the
  # expected root element.
  #
  # === Parameters
  # * src Source of XML (either a +File+ or +String+)
  # === Results
  # [object, name]
  # * object the root element
  # * name the element name of the matched root element
  #
  # Possible names:
  # * <code>schema</code>
  #
  # === Exceptions
  # InvalidXMLError
  #
  def self.parse(src)
    if src.is_a? REXML::Element
      root = src
    elsif src.is_a? File
      root = REXML::Document.new(src).root
    elsif src.is_a? String
      root = REXML::Document.new(src).root
    else
      e = ArgumentError.new "#{__method__} expects a File, String or REXML::Element"
      e.set_backtrace caller
      raise e
    end

    if root.name == 'schema' && root.namespace == NAMESPACE
      return [ parse_ComplexType_schemaType(root), 'schema' ]
    else
      raise InvalidXMLError, "element not defined in #{NAMESPACE}: {#{root.namespace}}#{root.name}"
    end
  end

end

#EOF
