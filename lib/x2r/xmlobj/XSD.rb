#!/usr/bin/ruby -w
#
# :title: XML objects
# = XML objects
#
# This module defines clases to represent an XML infoset that
# was defined by a set of XML Schemas. It also defines methods
# to parse an XML document into those objects and to serialize
# those objects into an XML document.
#
# Use the parse method to convert an XML document (from either
# a +File+ or a +String+) into objects.
#
# Invoke the +xml+ method on an object to serialize it into XML.
#
# == Example
#
# <pre>
# begin
#   src = File.new("example.xml")
#   obj, name = XSD.parser(src)
#   if name != 'expectedRootElementName'
#     ...
#   end
#
#   src.xml($stdout)
#
# rescue InvalidXMLError => e
#   ...
# rescue REXML:...
#   ...
# end
# </pre>

#--
# Generated code: do not edit
#
# Created by x2r-bootstrap.rb

require 'rexml/document'

module XSD

# Target XML namespace for this module.
NAMESPACE='http://www.w3.org/2001/XMLSchema'

  class Base
    # The REXML::node from which this object was parsed,
    # or +nil+ if this object was not parsed from XML.
    attr_writer :xml_src_node

    def expand_qname(qname)
      a, b = qname.split(':')
      if b
        # a=prefix; b=localname
        [ "http://debug.namespace/prefix/#{a}", b ] # TODO
      else
        # a=localname (in current namespace)
        [ 'http://debug.namespace/default-namespace', a ] # TODO
      end
    end

  end # class Base

# Class to represent the choice: choice1
#
# XSD::XSD_choice {
#   @maxOccurs = nil
#   @minOccurs = 0
#   @internal_member_name = "choice1"
#   @internal_class_name = "_anon2"
#   @element = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 0
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "include"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "include"
#       @minOccurs = 0
#       @type = "includeType"
#       @type_local = "includeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "import"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "import"
#       @minOccurs = 0
#       @type = "importType"
#       @type_local = "importType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Choice__anon2 < Base
  attr_accessor :xml_src_node
  # Names for the options in this choice.
  NAMES = [ :annotation, :include, :import,]

  def initialize
    super()
    @_index = nil
    @_value = nil
  end

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
    match == @_index ? @_value : nil
  end

  # Get the value of option +annotation+. Returns +nil+ if not the option.
  def annotation
    0 == @_index ? @_value : nil
  end
  # Set the choice to be option +annotation+ with the +value+.
  def annotation=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +include+. Returns +nil+ if not the option.
  def include
    1 == @_index ? @_value : nil
  end
  # Set the choice to be option +include+ with the +value+.
  def include=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +import+. Returns +nil+ if not the option.
  def import
    2 == @_index ? @_value : nil
  end
  # Set the choice to be option +import+ with the +value+.
  def import=(value)
    @_index = 2
    @_value = value
  end

def self.match(node)
  if node.name == 'annotation' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'include' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'import' && node.namespace == XSD::NAMESPACE
    true
  else
    false
  end
end # def match

  # Serialize as XML
  def xml(out, indent)
    if @_index
        # Non-primitive
        @_value.xml(NAMES[@_index], out, indent)
    end
  end

end # class Choice__anon2

#
# An array of Choice__anon2
#
class ChoiceList__anon2 < Array
  attr_accessor :xml_src_node

  # Serialize repeatable choices as XML
  def xml(out, indent)
    self.each { |opt| opt.xml(out, indent) }
  end

end # class ChoiceList__anon2

# Class to represent the choice: choice2
#
# XSD::XSD_choice {
#   @maxOccurs = nil
#   @minOccurs = 0
#   @internal_member_name = "choice2"
#   @internal_class_name = "_anon3"
#   @element = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 1
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "element"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "element"
#       @minOccurs = 1
#       @type = "elementType"
#       @type_local = "elementType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "attribute"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "attribute"
#       @minOccurs = 1
#       @type = "attributeType"
#       @type_local = "attributeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "simpleType"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "simpleType"
#       @minOccurs = 1
#       @type = "simpleTypeType"
#       @type_local = "simpleTypeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "complexType"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "complexType"
#       @minOccurs = 1
#       @type = "complexTypeType"
#       @type_local = "complexTypeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "attributeGroup"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "attributeGroup"
#       @minOccurs = 1
#       @type = "attributeGroupType"
#       @type_local = "attributeGroupType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Choice__anon3 < Base
  attr_accessor :xml_src_node
  # Names for the options in this choice.
  NAMES = [ :annotation, :element, :attribute, :simpleType, :complexType, :attributeGroup,]

  def initialize
    super()
    @_index = nil
    @_value = nil
  end

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
    match == @_index ? @_value : nil
  end

  # Get the value of option +annotation+. Returns +nil+ if not the option.
  def annotation
    0 == @_index ? @_value : nil
  end
  # Set the choice to be option +annotation+ with the +value+.
  def annotation=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +element+. Returns +nil+ if not the option.
  def element
    1 == @_index ? @_value : nil
  end
  # Set the choice to be option +element+ with the +value+.
  def element=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +attribute+. Returns +nil+ if not the option.
  def attribute
    2 == @_index ? @_value : nil
  end
  # Set the choice to be option +attribute+ with the +value+.
  def attribute=(value)
    @_index = 2
    @_value = value
  end

  # Get the value of option +simpleType+. Returns +nil+ if not the option.
  def simpleType
    3 == @_index ? @_value : nil
  end
  # Set the choice to be option +simpleType+ with the +value+.
  def simpleType=(value)
    @_index = 3
    @_value = value
  end

  # Get the value of option +complexType+. Returns +nil+ if not the option.
  def complexType
    4 == @_index ? @_value : nil
  end
  # Set the choice to be option +complexType+ with the +value+.
  def complexType=(value)
    @_index = 4
    @_value = value
  end

  # Get the value of option +attributeGroup+. Returns +nil+ if not the option.
  def attributeGroup
    5 == @_index ? @_value : nil
  end
  # Set the choice to be option +attributeGroup+ with the +value+.
  def attributeGroup=(value)
    @_index = 5
    @_value = value
  end

def self.match(node)
  if node.name == 'annotation' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'element' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'attribute' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'simpleType' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'complexType' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'attributeGroup' && node.namespace == XSD::NAMESPACE
    true
  else
    false
  end
end # def match

  # Serialize as XML
  def xml(out, indent)
    if @_index
        # Non-primitive
        @_value.xml(NAMES[@_index], out, indent)
    end
  end

end # class Choice__anon3

#
# An array of Choice__anon3
#
class ChoiceList__anon3 < Array
  attr_accessor :xml_src_node

  # Serialize repeatable choices as XML
  def xml(out, indent)
    self.each { |opt| opt.xml(out, indent) }
  end

end # class ChoiceList__anon3

# Class to represent the sequence: _anon1
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon1"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_choice {
#       @maxOccurs = nil
#       @minOccurs = 0
#       @internal_member_name = "choice1"
#       @internal_class_name = "_anon2"
#       @element = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 0
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "include"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "include"
#           @minOccurs = 0
#           @type = "includeType"
#           @type_local = "includeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "import"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "import"
#           @minOccurs = 0
#           @type = "importType"
#           @type_local = "importType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#     XSD::XSD_choice {
#       @maxOccurs = nil
#       @minOccurs = 0
#       @internal_member_name = "choice2"
#       @internal_class_name = "_anon3"
#       @element = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 1
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "element"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "element"
#           @minOccurs = 1
#           @type = "elementType"
#           @type_local = "elementType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "attribute"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "attribute"
#           @minOccurs = 1
#           @type = "attributeType"
#           @type_local = "attributeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "simpleType"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "simpleType"
#           @minOccurs = 1
#           @type = "simpleTypeType"
#           @type_local = "simpleTypeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "complexType"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "complexType"
#           @minOccurs = 1
#           @type = "complexTypeType"
#           @type_local = "complexTypeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "attributeGroup"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "attributeGroup"
#           @minOccurs = 1
#           @type = "attributeGroupType"
#           @type_local = "attributeGroupType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class Sequence__anon1
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :choice1
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :choice2

  def initialize
    super()
    @choice1 = []
    @choice2 = []
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
       @choice1.each { |m| m.xml(out, indent) }
       @choice2.each { |m| m.xml(out, indent) }
  end

end # class Sequence__anon1

# Class to represent the complexType: schemaType
#
# XSD::XSD_complexType {
#   @name = "schemaType"
#   @internal_name = "schemaType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "version"
#       @internal_name = "version"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "targetNamespace"
#       @internal_name = "targetNamespace"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "elementFormDefault"
#       @internal_name = "elementFormDefault"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "attributeFormDefault"
#       @internal_name = "attributeFormDefault"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = nil
#       @type = nil
#       @use = nil
#       @ref = "xml:lang"
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon1"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_choice {
#           @maxOccurs = nil
#           @minOccurs = 0
#           @internal_member_name = "choice1"
#           @internal_class_name = "_anon2"
#           @element = [
#             XSD::XSD_element {
#               @maxOccurs = nil
#               @name = "annotation"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "annotation"
#               @minOccurs = 0
#               @type = "annotationType"
#               @type_local = "annotationType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = nil
#               @name = "include"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "include"
#               @minOccurs = 0
#               @type = "includeType"
#               @type_local = "includeType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = nil
#               @name = "import"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "import"
#               @minOccurs = 0
#               @type = "importType"
#               @type_local = "importType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#           ]
#         }
#         XSD::XSD_choice {
#           @maxOccurs = nil
#           @minOccurs = 0
#           @internal_member_name = "choice2"
#           @internal_class_name = "_anon3"
#           @element = [
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "annotation"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "annotation"
#               @minOccurs = 1
#               @type = "annotationType"
#               @type_local = "annotationType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "element"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "element"
#               @minOccurs = 1
#               @type = "elementType"
#               @type_local = "elementType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "attribute"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "attribute"
#               @minOccurs = 1
#               @type = "attributeType"
#               @type_local = "attributeType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "simpleType"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "simpleType"
#               @minOccurs = 1
#               @type = "simpleTypeType"
#               @type_local = "simpleTypeType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "complexType"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "complexType"
#               @minOccurs = 1
#               @type = "complexTypeType"
#               @type_local = "complexTypeType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "attributeGroup"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "attributeGroup"
#               @minOccurs = 1
#               @type = "attributeGroupType"
#               @type_local = "attributeGroupType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }
class ComplexType_schemaType < Base
  attr_accessor :xml_src_node
  # Attribute <code>version</code> (optional, might be +nil+)
  attr_accessor :version
  # Attribute <code>targetNamespace</code> (optional, might be +nil+)
  attr_accessor :targetNamespace
  # Attribute <code>elementFormDefault</code> (optional, might be +nil+)
  attr_accessor :elementFormDefault
  # Attribute <code>attributeFormDefault</code> (optional, might be +nil+)
  attr_accessor :attributeFormDefault
  # Attribute <code></code> (optional, might be +nil+)
  attr_accessor :lang
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def choice1; @_sequence.choice1 end
  # Child element setter
  def choice1=(value); @_sequence.choice1(value) end
  # Child element getter
  def choice2; @_sequence.choice2 end
  # Child element setter
  def choice2=(value); @_sequence.choice2(value) end
  def initialize
    super()
    @version = nil
    @targetNamespace = nil
    @elementFormDefault = nil
    @attributeFormDefault = nil
    @lang = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @version
      out.print " version=\"#{XSD.pcdata(@version)}\""
    end
    if @targetNamespace
      out.print " targetNamespace=\"#{XSD.pcdata(@targetNamespace)}\""
    end
    if @elementFormDefault
      out.print " elementFormDefault=\"#{XSD.pcdata(@elementFormDefault)}\""
    end
    if @attributeFormDefault
      out.print " attributeFormDefault=\"#{XSD.pcdata(@attributeFormDefault)}\""
    end
    if @lang
      out.print " xsd:lang=\"#{XSD.pcdata(@lang)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_schemaType

# Class to represent the sequence: _anon4
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon4"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "documentation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "documentation"
#       @minOccurs = 0
#       @type = "documentationType"
#       @type_local = "documentationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Sequence__anon4
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :documentation

  def initialize
    super()
    @documentation = []
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @documentation.empty?
      @documentation.each { |m| m.xml('documentation', out, indent) }
    end
  end

end # class Sequence__anon4

# Class to represent the complexType: annotationType
#
# XSD::XSD_complexType {
#   @name = "annotationType"
#   @internal_name = "annotationType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = nil
#       @type = nil
#       @use = nil
#       @ref = "xml:lang"
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon4"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "documentation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "documentation"
#           @minOccurs = 0
#           @type = "documentationType"
#           @type_local = "documentationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class ComplexType_annotationType < Base
  attr_accessor :xml_src_node
  # Attribute <code></code> (optional, might be +nil+)
  attr_accessor :lang
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def documentation; @_sequence.documentation end
  # Child element setter
  def documentation=(value); @_sequence.documentation(value) end
  def initialize
    super()
    @lang = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @lang
      out.print " xsd:lang=\"#{XSD.pcdata(@lang)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_annotationType

# Class to represent the complexType: documentationType
#
# XSD::XSD_complexType {
#   @name = "documentationType"
#   @internal_name = "documentationType"
#   @simpleContent = [
#     XSD::XSD_simpleContent {
#       @extension = [
#         XSD::XSD_extension {
#           @base = "xsd:string"
#           @attribute = [
#             XSD::XSD_attribute {
#               @name = "source"
#               @internal_name = "source"
#               @type = "xsd:string"
#               @use = nil
#               @ref = nil
#             }
#             XSD::XSD_attribute {
#               @name = nil
#               @type = nil
#               @use = nil
#               @ref = "xml:lang"
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }
class ComplexType_documentationType < Base
  attr_accessor :xml_src_node
  # Attribute <code>source</code> (optional, might be +nil+)
  attr_accessor :source
  # Attribute <code></code> (optional, might be +nil+)
  attr_accessor :lang
  # The simpleContent value as a +String+.
  # In XML Schema, this is an extension of <code>xsd:string</code>.
  attr_accessor :_value

  def initialize
    super()
  end
  # Serialize as XML
  def xml(ename, out, indent)
    out.print "#{indent}<#{ename}" # start tag for extension
    if @source
      out.print " source=\"#{XSD.pcdata(@source)}\""
    end
    if @lang
      out.print " xsd:lang=\"#{XSD.pcdata(@lang)}\""
    end
    out.print '>'
    out.print XSD.cdata(@_value)
    out.print "</#{ename}>\n" # end tag
  end # def xml

end # class ComplexType_documentationType

# Class to represent the complexType: includeType
#
# XSD::XSD_complexType {
#   @name = "includeType"
#   @internal_name = "includeType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "schemaLocation"
#       @internal_name = "schemaLocation"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#   ]
# }
class ComplexType_includeType < Base
  attr_accessor :xml_src_node
  # Attribute <code>schemaLocation</code> (optional, might be +nil+)
  attr_accessor :schemaLocation
  def initialize
    super()
    @schemaLocation = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @schemaLocation
      out.print " schemaLocation=\"#{XSD.pcdata(@schemaLocation)}\""
    end
    out.print ">"
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_includeType

# Class to represent the complexType: importType
#
# XSD::XSD_complexType {
#   @name = "importType"
#   @internal_name = "importType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "namespace"
#       @internal_name = "namespace"
#       @type = "xsd:string"
#       @use = "required"
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "schemaLocation"
#       @internal_name = "schemaLocation"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#   ]
# }
class ComplexType_importType < Base
  attr_accessor :xml_src_node
  # Attribute <code>namespace</code> (required, always has a value)
  attr_accessor :namespace
  # Attribute <code>schemaLocation</code> (optional, might be +nil+)
  attr_accessor :schemaLocation
  def initialize
    super()
    @namespace = nil
    @schemaLocation = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @namespace
      out.print " namespace=\"#{XSD.pcdata(@namespace)}\""
    end
    if @schemaLocation
      out.print " schemaLocation=\"#{XSD.pcdata(@schemaLocation)}\""
    end
    out.print ">"
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_importType

# Class to represent the sequence: _anon5
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon5"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "extension"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "extension"
#       @minOccurs = 1
#       @type = "extensionType"
#       @type_local = "extensionType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Sequence__anon5
  attr_accessor :xml_src_node
  # Single mandatory child element.
  # Value is never +nil+.
  attr_accessor :extension

  def initialize
    super()
    @extension = nil
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if @extension
      @extension.xml('extension', out, indent)
    end
  end

end # class Sequence__anon5

# Class to represent the complexType: simpleContentType
#
# XSD::XSD_complexType {
#   @name = "simpleContentType"
#   @internal_name = "simpleContentType"
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon5"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "extension"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "extension"
#           @minOccurs = 1
#           @type = "extensionType"
#           @type_local = "extensionType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class ComplexType_simpleContentType < Base
  attr_accessor :xml_src_node
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def extension; @_sequence.extension end
  # Child element setter
  def extension=(value); @_sequence.extension(value) end
  def initialize
    super()
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_simpleContentType

# Class to represent the sequence: _anon6
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon6"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "attribute"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "attribute"
#       @minOccurs = 1
#       @type = "attributeType"
#       @type_local = "attributeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 0
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Sequence__anon6
  attr_accessor :xml_src_node
  # Mandatory and repeatable elements represented by an array.
  # The array always has at least 1 members.
  attr_accessor :attribute
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :annotation

  def initialize
    super()
    @attribute = []
    @annotation = []
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @attribute.empty?
      @attribute.each { |m| m.xml('attribute', out, indent) }
    end
    if ! @annotation.empty?
      @annotation.each { |m| m.xml('annotation', out, indent) }
    end
  end

end # class Sequence__anon6

# Class to represent the complexType: extensionType
#
# XSD::XSD_complexType {
#   @name = "extensionType"
#   @internal_name = "extensionType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "base"
#       @internal_name = "base"
#       @type = "xsd:string"
#       @use = "required"
#       @ref = nil
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon6"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "attribute"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "attribute"
#           @minOccurs = 1
#           @type = "attributeType"
#           @type_local = "attributeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 0
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class ComplexType_extensionType < Base
  attr_accessor :xml_src_node
  # Attribute <code>base</code> (required, always has a value)
  attr_accessor :base
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def attribute; @_sequence.attribute end
  # Child element setter
  def attribute=(value); @_sequence.attribute(value) end
  # Child element getter
  def annotation; @_sequence.annotation end
  # Child element setter
  def annotation=(value); @_sequence.annotation(value) end
  def initialize
    super()
    @base = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @base
      out.print " base=\"#{XSD.pcdata(@base)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_extensionType

# Class to represent the choice: choice
#
# XSD::XSD_choice {
#   @maxOccurs = 1
#   @minOccurs = 0
#   @internal_member_name = "choice"
#   @internal_class_name = "_anon8"
#   @element = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "complexType"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "complexType"
#       @minOccurs = 1
#       @type = "complexTypeType"
#       @type_local = "complexTypeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Choice__anon8 < Base
  attr_accessor :xml_src_node
  # Names for the options in this choice.
  NAMES = [ :complexType,]

  def initialize
    super()
    @_index = nil
    @_value = nil
  end

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
    match == @_index ? @_value : nil
  end

  # Get the value of option +complexType+. Returns +nil+ if not the option.
  def complexType
    0 == @_index ? @_value : nil
  end
  # Set the choice to be option +complexType+ with the +value+.
  def complexType=(value)
    @_index = 0
    @_value = value
  end

def self.match(node)
  if node.name == 'complexType' && node.namespace == XSD::NAMESPACE
    true
  else
    false
  end
end # def match

  # Serialize as XML
  def xml(out, indent)
    if @_index
        # Non-primitive
        @_value.xml(NAMES[@_index], out, indent)
    end
  end

end # class Choice__anon8

# Class to represent the sequence: _anon7
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon7"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 0
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_choice {
#       @maxOccurs = 1
#       @minOccurs = 0
#       @internal_member_name = "choice"
#       @internal_class_name = "_anon8"
#       @element = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "complexType"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "complexType"
#           @minOccurs = 1
#           @type = "complexTypeType"
#           @type_local = "complexTypeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class Sequence__anon7
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :annotation
  # Single optional child element.
  # Value is +nil+ if the element is not present.
  attr_accessor :choice

  def initialize
    super()
    @annotation = []
    @choice = nil
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @annotation.empty?
      @annotation.each { |m| m.xml('annotation', out, indent) }
    end
    if @choice
      @choice.xml(out, indent)
    end
  end

end # class Sequence__anon7

# Class to represent the complexType: elementType
#
# XSD::XSD_complexType {
#   @name = "elementType"
#   @internal_name = "elementType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "name"
#       @internal_name = "name"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "type"
#       @internal_name = "type_attribute"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "minOccurs"
#       @internal_name = "minOccurs"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "maxOccurs"
#       @internal_name = "maxOccurs"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "ref"
#       @internal_name = "ref"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon7"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 0
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_choice {
#           @maxOccurs = 1
#           @minOccurs = 0
#           @internal_member_name = "choice"
#           @internal_class_name = "_anon8"
#           @element = [
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "complexType"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "complexType"
#               @minOccurs = 1
#               @type = "complexTypeType"
#               @type_local = "complexTypeType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }
class ComplexType_elementType < Base
  attr_accessor :xml_src_node
  # Attribute <code>name</code> (optional, might be +nil+)
  attr_accessor :name
  # Attribute <code>type</code> (optional, might be +nil+)
  attr_accessor :type_attribute
  # Attribute <code>minOccurs</code> (optional, might be +nil+)
  attr_accessor :minOccurs
  # Attribute <code>maxOccurs</code> (optional, might be +nil+)
  attr_accessor :maxOccurs
  # Attribute <code>ref</code> (optional, might be +nil+)
  attr_accessor :ref
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def annotation; @_sequence.annotation end
  # Child element setter
  def annotation=(value); @_sequence.annotation(value) end
  # Child element getter
  def choice; @_sequence.choice end
  # Child element setter
  def choice=(value); @_sequence.choice(value) end
  def initialize
    super()
    @name = nil
    @type_attribute = nil
    @minOccurs = nil
    @maxOccurs = nil
    @ref = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @name
      out.print " name=\"#{XSD.pcdata(@name)}\""
    end
    if @type_attribute
      out.print " type=\"#{XSD.pcdata(@type_attribute)}\""
    end
    if @minOccurs
      out.print " minOccurs=\"#{XSD.pcdata(@minOccurs)}\""
    end
    if @maxOccurs
      out.print " maxOccurs=\"#{XSD.pcdata(@maxOccurs)}\""
    end
    if @ref
      out.print " ref=\"#{XSD.pcdata(@ref)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_elementType

# Class to represent the complexType: enumerationType
#
# XSD::XSD_complexType {
#   @name = "enumerationType"
#   @internal_name = "enumerationType"
#   @simpleContent = [
#     XSD::XSD_simpleContent {
#       @extension = [
#         XSD::XSD_extension {
#           @base = "xsd:string"
#           @attribute = [
#             XSD::XSD_attribute {
#               @name = "value"
#               @internal_name = "value"
#               @type = "xsd:string"
#               @use = nil
#               @ref = nil
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }
class ComplexType_enumerationType < Base
  attr_accessor :xml_src_node
  # Attribute <code>value</code> (optional, might be +nil+)
  attr_accessor :value
  # The simpleContent value as a +String+.
  # In XML Schema, this is an extension of <code>xsd:string</code>.
  attr_accessor :_value

  def initialize
    super()
  end
  # Serialize as XML
  def xml(ename, out, indent)
    out.print "#{indent}<#{ename}" # start tag for extension
    if @value
      out.print " value=\"#{XSD.pcdata(@value)}\""
    end
    out.print '>'
    out.print XSD.cdata(@_value)
    out.print "</#{ename}>\n" # end tag
  end # def xml

end # class ComplexType_enumerationType

# Class to represent the sequence: _anon9
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon9"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "enumeration"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "enumeration"
#       @minOccurs = 0
#       @type = "enumerationType"
#       @type_local = "enumerationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Sequence__anon9
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :enumeration

  def initialize
    super()
    @enumeration = []
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @enumeration.empty?
      @enumeration.each { |m| m.xml('enumeration', out, indent) }
    end
  end

end # class Sequence__anon9

# Class to represent the complexType: restrictionType
#
# XSD::XSD_complexType {
#   @name = "restrictionType"
#   @internal_name = "restrictionType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "base"
#       @internal_name = "base"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon9"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "enumeration"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "enumeration"
#           @minOccurs = 0
#           @type = "enumerationType"
#           @type_local = "enumerationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class ComplexType_restrictionType < Base
  attr_accessor :xml_src_node
  # Attribute <code>base</code> (optional, might be +nil+)
  attr_accessor :base
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def enumeration; @_sequence.enumeration end
  # Child element setter
  def enumeration=(value); @_sequence.enumeration(value) end
  def initialize
    super()
    @base = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @base
      out.print " base=\"#{XSD.pcdata(@base)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_restrictionType

# Class to represent the sequence: _anon10
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon10"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "restriction"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "restriction"
#       @minOccurs = 1
#       @type = "restrictionType"
#       @type_local = "restrictionType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Sequence__anon10
  attr_accessor :xml_src_node
  # Single mandatory child element.
  # Value is never +nil+.
  attr_accessor :restriction

  def initialize
    super()
    @restriction = nil
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if @restriction
      @restriction.xml('restriction', out, indent)
    end
  end

end # class Sequence__anon10

# Class to represent the complexType: simpleTypeType
#
# XSD::XSD_complexType {
#   @name = "simpleTypeType"
#   @internal_name = "simpleTypeType"
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon10"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "restriction"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "restriction"
#           @minOccurs = 1
#           @type = "restrictionType"
#           @type_local = "restrictionType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class ComplexType_simpleTypeType < Base
  attr_accessor :xml_src_node
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def restriction; @_sequence.restriction end
  # Child element setter
  def restriction=(value); @_sequence.restriction(value) end
  def initialize
    super()
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_simpleTypeType

# Class to represent the choice: choice1
#
# XSD::XSD_choice {
#   @maxOccurs = 1
#   @minOccurs = 0
#   @internal_member_name = "choice1"
#   @internal_class_name = "_anon12"
#   @element = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "simpleContent"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "simpleContent"
#       @minOccurs = 1
#       @type = "simpleContentType"
#       @type_local = "simpleContentType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "sequence"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "sequence"
#       @minOccurs = 1
#       @type = "sequenceType"
#       @type_local = "sequenceType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "choice"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "choice"
#       @minOccurs = 1
#       @type = "choiceType"
#       @type_local = "choiceType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Choice__anon12 < Base
  attr_accessor :xml_src_node
  # Names for the options in this choice.
  NAMES = [ :simpleContent, :sequence, :choice,]

  def initialize
    super()
    @_index = nil
    @_value = nil
  end

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
    match == @_index ? @_value : nil
  end

  # Get the value of option +simpleContent+. Returns +nil+ if not the option.
  def simpleContent
    0 == @_index ? @_value : nil
  end
  # Set the choice to be option +simpleContent+ with the +value+.
  def simpleContent=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +sequence+. Returns +nil+ if not the option.
  def sequence
    1 == @_index ? @_value : nil
  end
  # Set the choice to be option +sequence+ with the +value+.
  def sequence=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +choice+. Returns +nil+ if not the option.
  def choice
    2 == @_index ? @_value : nil
  end
  # Set the choice to be option +choice+ with the +value+.
  def choice=(value)
    @_index = 2
    @_value = value
  end

def self.match(node)
  if node.name == 'simpleContent' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'sequence' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'choice' && node.namespace == XSD::NAMESPACE
    true
  else
    false
  end
end # def match

  # Serialize as XML
  def xml(out, indent)
    if @_index
        # Non-primitive
        @_value.xml(NAMES[@_index], out, indent)
    end
  end

end # class Choice__anon12

# Class to represent the choice: choice2
#
# XSD::XSD_choice {
#   @maxOccurs = nil
#   @minOccurs = 0
#   @internal_member_name = "choice2"
#   @internal_class_name = "_anon13"
#   @element = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "attribute"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "attribute"
#       @minOccurs = 1
#       @type = "attributeType"
#       @type_local = "attributeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "attributeGroup"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "attributeGroup"
#       @minOccurs = 1
#       @type = "attributeGroupType"
#       @type_local = "attributeGroupType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Choice__anon13 < Base
  attr_accessor :xml_src_node
  # Names for the options in this choice.
  NAMES = [ :attribute, :attributeGroup,]

  def initialize
    super()
    @_index = nil
    @_value = nil
  end

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
    match == @_index ? @_value : nil
  end

  # Get the value of option +attribute+. Returns +nil+ if not the option.
  def attribute
    0 == @_index ? @_value : nil
  end
  # Set the choice to be option +attribute+ with the +value+.
  def attribute=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +attributeGroup+. Returns +nil+ if not the option.
  def attributeGroup
    1 == @_index ? @_value : nil
  end
  # Set the choice to be option +attributeGroup+ with the +value+.
  def attributeGroup=(value)
    @_index = 1
    @_value = value
  end

def self.match(node)
  if node.name == 'attribute' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'attributeGroup' && node.namespace == XSD::NAMESPACE
    true
  else
    false
  end
end # def match

  # Serialize as XML
  def xml(out, indent)
    if @_index
        # Non-primitive
        @_value.xml(NAMES[@_index], out, indent)
    end
  end

end # class Choice__anon13

#
# An array of Choice__anon13
#
class ChoiceList__anon13 < Array
  attr_accessor :xml_src_node

  # Serialize repeatable choices as XML
  def xml(out, indent)
    self.each { |opt| opt.xml(out, indent) }
  end

end # class ChoiceList__anon13

# Class to represent the sequence: _anon11
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon11"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 0
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_choice {
#       @maxOccurs = 1
#       @minOccurs = 0
#       @internal_member_name = "choice1"
#       @internal_class_name = "_anon12"
#       @element = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "simpleContent"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "simpleContent"
#           @minOccurs = 1
#           @type = "simpleContentType"
#           @type_local = "simpleContentType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "sequence"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "sequence"
#           @minOccurs = 1
#           @type = "sequenceType"
#           @type_local = "sequenceType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "choice"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "choice"
#           @minOccurs = 1
#           @type = "choiceType"
#           @type_local = "choiceType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#     XSD::XSD_choice {
#       @maxOccurs = nil
#       @minOccurs = 0
#       @internal_member_name = "choice2"
#       @internal_class_name = "_anon13"
#       @element = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "attribute"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "attribute"
#           @minOccurs = 1
#           @type = "attributeType"
#           @type_local = "attributeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "attributeGroup"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "attributeGroup"
#           @minOccurs = 1
#           @type = "attributeGroupType"
#           @type_local = "attributeGroupType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class Sequence__anon11
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :annotation
  # Single optional child element.
  # Value is +nil+ if the element is not present.
  attr_accessor :choice1
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :choice2

  def initialize
    super()
    @annotation = []
    @choice1 = nil
    @choice2 = []
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @annotation.empty?
      @annotation.each { |m| m.xml('annotation', out, indent) }
    end
    if @choice1
      @choice1.xml(out, indent)
    end
       @choice2.each { |m| m.xml(out, indent) }
  end

end # class Sequence__anon11

# Class to represent the complexType: complexTypeType
#
# XSD::XSD_complexType {
#   @name = "complexTypeType"
#   @internal_name = "complexTypeType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "name"
#       @internal_name = "name"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon11"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 0
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_choice {
#           @maxOccurs = 1
#           @minOccurs = 0
#           @internal_member_name = "choice1"
#           @internal_class_name = "_anon12"
#           @element = [
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "simpleContent"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "simpleContent"
#               @minOccurs = 1
#               @type = "simpleContentType"
#               @type_local = "simpleContentType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "sequence"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "sequence"
#               @minOccurs = 1
#               @type = "sequenceType"
#               @type_local = "sequenceType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "choice"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "choice"
#               @minOccurs = 1
#               @type = "choiceType"
#               @type_local = "choiceType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#           ]
#         }
#         XSD::XSD_choice {
#           @maxOccurs = nil
#           @minOccurs = 0
#           @internal_member_name = "choice2"
#           @internal_class_name = "_anon13"
#           @element = [
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "attribute"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "attribute"
#               @minOccurs = 1
#               @type = "attributeType"
#               @type_local = "attributeType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "attributeGroup"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "attributeGroup"
#               @minOccurs = 1
#               @type = "attributeGroupType"
#               @type_local = "attributeGroupType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }
class ComplexType_complexTypeType < Base
  attr_accessor :xml_src_node
  # Attribute <code>name</code> (optional, might be +nil+)
  attr_accessor :name
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def annotation; @_sequence.annotation end
  # Child element setter
  def annotation=(value); @_sequence.annotation(value) end
  # Child element getter
  def choice1; @_sequence.choice1 end
  # Child element setter
  def choice1=(value); @_sequence.choice1(value) end
  # Child element getter
  def choice2; @_sequence.choice2 end
  # Child element setter
  def choice2=(value); @_sequence.choice2(value) end
  def initialize
    super()
    @name = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @name
      out.print " name=\"#{XSD.pcdata(@name)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_complexTypeType

# Class to represent the choice: choice
#
# XSD::XSD_choice {
#   @maxOccurs = nil
#   @minOccurs = 1
#   @internal_member_name = "choice"
#   @internal_class_name = "_anon15"
#   @element = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "element"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "element"
#       @minOccurs = 1
#       @type = "elementType"
#       @type_local = "elementType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "sequence"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "sequence"
#       @minOccurs = 1
#       @type = "sequenceType"
#       @type_local = "sequenceType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "choice"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "choice"
#       @minOccurs = 1
#       @type = "choiceType"
#       @type_local = "choiceType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Choice__anon15 < Base
  attr_accessor :xml_src_node
  # Names for the options in this choice.
  NAMES = [ :element, :sequence, :choice,]

  def initialize
    super()
    @_index = nil
    @_value = nil
  end

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
    match == @_index ? @_value : nil
  end

  # Get the value of option +element+. Returns +nil+ if not the option.
  def element
    0 == @_index ? @_value : nil
  end
  # Set the choice to be option +element+ with the +value+.
  def element=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +sequence+. Returns +nil+ if not the option.
  def sequence
    1 == @_index ? @_value : nil
  end
  # Set the choice to be option +sequence+ with the +value+.
  def sequence=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +choice+. Returns +nil+ if not the option.
  def choice
    2 == @_index ? @_value : nil
  end
  # Set the choice to be option +choice+ with the +value+.
  def choice=(value)
    @_index = 2
    @_value = value
  end

def self.match(node)
  if node.name == 'element' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'sequence' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'choice' && node.namespace == XSD::NAMESPACE
    true
  else
    false
  end
end # def match

  # Serialize as XML
  def xml(out, indent)
    if @_index
        # Non-primitive
        @_value.xml(NAMES[@_index], out, indent)
    end
  end

end # class Choice__anon15

#
# An array of Choice__anon15
#
class ChoiceList__anon15 < Array
  attr_accessor :xml_src_node

  # Serialize repeatable choices as XML
  def xml(out, indent)
    self.each { |opt| opt.xml(out, indent) }
  end

end # class ChoiceList__anon15

# Class to represent the sequence: _anon14
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon14"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 0
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_choice {
#       @maxOccurs = nil
#       @minOccurs = 1
#       @internal_member_name = "choice"
#       @internal_class_name = "_anon15"
#       @element = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "element"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "element"
#           @minOccurs = 1
#           @type = "elementType"
#           @type_local = "elementType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "sequence"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "sequence"
#           @minOccurs = 1
#           @type = "sequenceType"
#           @type_local = "sequenceType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "choice"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "choice"
#           @minOccurs = 1
#           @type = "choiceType"
#           @type_local = "choiceType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class Sequence__anon14
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :annotation
  # Mandatory and repeatable elements represented by an array.
  # The array always has at least 1 members.
  attr_accessor :choice

  def initialize
    super()
    @annotation = []
    @choice = []
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @annotation.empty?
      @annotation.each { |m| m.xml('annotation', out, indent) }
    end
       @choice.each { |m| m.xml(out, indent) }
  end

end # class Sequence__anon14

# Class to represent the complexType: sequenceType
#
# XSD::XSD_complexType {
#   @name = "sequenceType"
#   @internal_name = "sequenceType"
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon14"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 0
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_choice {
#           @maxOccurs = nil
#           @minOccurs = 1
#           @internal_member_name = "choice"
#           @internal_class_name = "_anon15"
#           @element = [
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "element"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "element"
#               @minOccurs = 1
#               @type = "elementType"
#               @type_local = "elementType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "sequence"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "sequence"
#               @minOccurs = 1
#               @type = "sequenceType"
#               @type_local = "sequenceType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "choice"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "choice"
#               @minOccurs = 1
#               @type = "choiceType"
#               @type_local = "choiceType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }
class ComplexType_sequenceType < Base
  attr_accessor :xml_src_node
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def annotation; @_sequence.annotation end
  # Child element setter
  def annotation=(value); @_sequence.annotation(value) end
  # Child element getter
  def choice; @_sequence.choice end
  # Child element setter
  def choice=(value); @_sequence.choice(value) end
  def initialize
    super()
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_sequenceType

# Class to represent the choice: choice
#
# XSD::XSD_choice {
#   @maxOccurs = nil
#   @minOccurs = 1
#   @internal_member_name = "choice"
#   @internal_class_name = "_anon17"
#   @element = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "element"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "element"
#       @minOccurs = 1
#       @type = "elementType"
#       @type_local = "elementType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "sequence"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "sequence"
#       @minOccurs = 1
#       @type = "sequenceType"
#       @type_local = "sequenceType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "choice"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "choice"
#       @minOccurs = 1
#       @type = "choiceType"
#       @type_local = "choiceType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Choice__anon17 < Base
  attr_accessor :xml_src_node
  # Names for the options in this choice.
  NAMES = [ :element, :sequence, :choice,]

  def initialize
    super()
    @_index = nil
    @_value = nil
  end

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
    match == @_index ? @_value : nil
  end

  # Get the value of option +element+. Returns +nil+ if not the option.
  def element
    0 == @_index ? @_value : nil
  end
  # Set the choice to be option +element+ with the +value+.
  def element=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +sequence+. Returns +nil+ if not the option.
  def sequence
    1 == @_index ? @_value : nil
  end
  # Set the choice to be option +sequence+ with the +value+.
  def sequence=(value)
    @_index = 1
    @_value = value
  end

  # Get the value of option +choice+. Returns +nil+ if not the option.
  def choice
    2 == @_index ? @_value : nil
  end
  # Set the choice to be option +choice+ with the +value+.
  def choice=(value)
    @_index = 2
    @_value = value
  end

def self.match(node)
  if node.name == 'element' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'sequence' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'choice' && node.namespace == XSD::NAMESPACE
    true
  else
    false
  end
end # def match

  # Serialize as XML
  def xml(out, indent)
    if @_index
        # Non-primitive
        @_value.xml(NAMES[@_index], out, indent)
    end
  end

end # class Choice__anon17

#
# An array of Choice__anon17
#
class ChoiceList__anon17 < Array
  attr_accessor :xml_src_node

  # Serialize repeatable choices as XML
  def xml(out, indent)
    self.each { |opt| opt.xml(out, indent) }
  end

end # class ChoiceList__anon17

# Class to represent the sequence: _anon16
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon16"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 0
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_choice {
#       @maxOccurs = nil
#       @minOccurs = 1
#       @internal_member_name = "choice"
#       @internal_class_name = "_anon17"
#       @element = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "element"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "element"
#           @minOccurs = 1
#           @type = "elementType"
#           @type_local = "elementType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "sequence"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "sequence"
#           @minOccurs = 1
#           @type = "sequenceType"
#           @type_local = "sequenceType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "choice"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "choice"
#           @minOccurs = 1
#           @type = "choiceType"
#           @type_local = "choiceType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class Sequence__anon16
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :annotation
  # Mandatory and repeatable elements represented by an array.
  # The array always has at least 1 members.
  attr_accessor :choice

  def initialize
    super()
    @annotation = []
    @choice = []
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @annotation.empty?
      @annotation.each { |m| m.xml('annotation', out, indent) }
    end
       @choice.each { |m| m.xml(out, indent) }
  end

end # class Sequence__anon16

# Class to represent the complexType: choiceType
#
# XSD::XSD_complexType {
#   @name = "choiceType"
#   @internal_name = "choiceType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "minOccurs"
#       @internal_name = "minOccurs"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "maxOccurs"
#       @internal_name = "maxOccurs"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon16"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 0
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_choice {
#           @maxOccurs = nil
#           @minOccurs = 1
#           @internal_member_name = "choice"
#           @internal_class_name = "_anon17"
#           @element = [
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "element"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "element"
#               @minOccurs = 1
#               @type = "elementType"
#               @type_local = "elementType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "sequence"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "sequence"
#               @minOccurs = 1
#               @type = "sequenceType"
#               @type_local = "sequenceType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "choice"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "choice"
#               @minOccurs = 1
#               @type = "choiceType"
#               @type_local = "choiceType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }
class ComplexType_choiceType < Base
  attr_accessor :xml_src_node
  # Attribute <code>minOccurs</code> (optional, might be +nil+)
  attr_accessor :minOccurs
  # Attribute <code>maxOccurs</code> (optional, might be +nil+)
  attr_accessor :maxOccurs
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def annotation; @_sequence.annotation end
  # Child element setter
  def annotation=(value); @_sequence.annotation(value) end
  # Child element getter
  def choice; @_sequence.choice end
  # Child element setter
  def choice=(value); @_sequence.choice(value) end
  def initialize
    super()
    @minOccurs = nil
    @maxOccurs = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @minOccurs
      out.print " minOccurs=\"#{XSD.pcdata(@minOccurs)}\""
    end
    if @maxOccurs
      out.print " maxOccurs=\"#{XSD.pcdata(@maxOccurs)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_choiceType

# Class to represent the sequence: _anon18
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon18"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 0
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "simpleType"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "simpleType"
#       @minOccurs = 0
#       @type = "simpleTypeType"
#       @type_local = "simpleTypeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Sequence__anon18
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :annotation
  # Single optional child element.
  # Value is +nil+ if the element is not present.
  attr_accessor :simpleType

  def initialize
    super()
    @annotation = []
    @simpleType = nil
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @annotation.empty?
      @annotation.each { |m| m.xml('annotation', out, indent) }
    end
    if @simpleType
      @simpleType.xml('simpleType', out, indent)
    end
  end

end # class Sequence__anon18

# Class to represent the complexType: attributeType
#
# XSD::XSD_complexType {
#   @name = "attributeType"
#   @internal_name = "attributeType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "name"
#       @internal_name = "name"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "type"
#       @internal_name = "type_attribute"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "ref"
#       @internal_name = "ref"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "use"
#       @internal_name = "use"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon18"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 0
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "simpleType"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "simpleType"
#           @minOccurs = 0
#           @type = "simpleTypeType"
#           @type_local = "simpleTypeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class ComplexType_attributeType < Base
  attr_accessor :xml_src_node
  # Attribute <code>name</code> (optional, might be +nil+)
  attr_accessor :name
  # Attribute <code>type</code> (optional, might be +nil+)
  attr_accessor :type_attribute
  # Attribute <code>ref</code> (optional, might be +nil+)
  attr_accessor :ref
  # Attribute <code>use</code> (optional, might be +nil+)
  attr_accessor :use
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def annotation; @_sequence.annotation end
  # Child element setter
  def annotation=(value); @_sequence.annotation(value) end
  # Child element getter
  def simpleType; @_sequence.simpleType end
  # Child element setter
  def simpleType=(value); @_sequence.simpleType(value) end
  def initialize
    super()
    @name = nil
    @type_attribute = nil
    @ref = nil
    @use = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @name
      out.print " name=\"#{XSD.pcdata(@name)}\""
    end
    if @type_attribute
      out.print " type=\"#{XSD.pcdata(@type_attribute)}\""
    end
    if @ref
      out.print " ref=\"#{XSD.pcdata(@ref)}\""
    end
    if @use
      out.print " use=\"#{XSD.pcdata(@use)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_attributeType

# Class to represent the choice: choice
#
# XSD::XSD_choice {
#   @maxOccurs = nil
#   @minOccurs = 0
#   @internal_member_name = "choice"
#   @internal_class_name = "_anon20"
#   @element = [
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "attribute"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "attribute"
#       @minOccurs = 1
#       @type = "attributeType"
#       @type_local = "attributeType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_element {
#       @maxOccurs = 1
#       @name = "attributeGroup"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "attributeGroup"
#       @minOccurs = 1
#       @type = "attributeGroupType"
#       @type_local = "attributeGroupType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#   ]
# }
class Choice__anon20 < Base
  attr_accessor :xml_src_node
  # Names for the options in this choice.
  NAMES = [ :attribute, :attributeGroup,]

  def initialize
    super()
    @_index = nil
    @_value = nil
  end

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
    match == @_index ? @_value : nil
  end

  # Get the value of option +attribute+. Returns +nil+ if not the option.
  def attribute
    0 == @_index ? @_value : nil
  end
  # Set the choice to be option +attribute+ with the +value+.
  def attribute=(value)
    @_index = 0
    @_value = value
  end

  # Get the value of option +attributeGroup+. Returns +nil+ if not the option.
  def attributeGroup
    1 == @_index ? @_value : nil
  end
  # Set the choice to be option +attributeGroup+ with the +value+.
  def attributeGroup=(value)
    @_index = 1
    @_value = value
  end

def self.match(node)
  if node.name == 'attribute' && node.namespace == XSD::NAMESPACE
    true
  elsif node.name == 'attributeGroup' && node.namespace == XSD::NAMESPACE
    true
  else
    false
  end
end # def match

  # Serialize as XML
  def xml(out, indent)
    if @_index
        # Non-primitive
        @_value.xml(NAMES[@_index], out, indent)
    end
  end

end # class Choice__anon20

#
# An array of Choice__anon20
#
class ChoiceList__anon20 < Array
  attr_accessor :xml_src_node

  # Serialize repeatable choices as XML
  def xml(out, indent)
    self.each { |opt| opt.xml(out, indent) }
  end

end # class ChoiceList__anon20

# Class to represent the sequence: _anon19
#
# XSD::XSD_sequence {
#   @maxOccurs = 1
#   @internal_name = "_anon19"
#   @minOccurs = 1
#   @members = [
#     XSD::XSD_element {
#       @maxOccurs = nil
#       @name = "annotation"
#       @name_ns = "http://www.w3.org/2001/XMLSchema"
#       @internal_name = "annotation"
#       @minOccurs = 0
#       @type = "annotationType"
#       @type_local = "annotationType"
#       @type_ns = "http://www.w3.org/2001/XMLSchema"
#       @ref = nil
#     }
#     XSD::XSD_choice {
#       @maxOccurs = nil
#       @minOccurs = 0
#       @internal_member_name = "choice"
#       @internal_class_name = "_anon20"
#       @element = [
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "attribute"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "attribute"
#           @minOccurs = 1
#           @type = "attributeType"
#           @type_local = "attributeType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_element {
#           @maxOccurs = 1
#           @name = "attributeGroup"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "attributeGroup"
#           @minOccurs = 1
#           @type = "attributeGroupType"
#           @type_local = "attributeGroupType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#       ]
#     }
#   ]
# }
class Sequence__anon19
  attr_accessor :xml_src_node
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :annotation
  # Optional and repeatable elements represented by an array.
  # The array could be empty.
  attr_accessor :choice

  def initialize
    super()
    @annotation = []
    @choice = []
  end

  # Serialize sequence as XML
  def xml(out, indent)
    indent += '  '
    if ! @annotation.empty?
      @annotation.each { |m| m.xml('annotation', out, indent) }
    end
       @choice.each { |m| m.xml(out, indent) }
  end

end # class Sequence__anon19

# Class to represent the complexType: attributeGroupType
#
# XSD::XSD_complexType {
#   @name = "attributeGroupType"
#   @internal_name = "attributeGroupType"
#   @attribute = [
#     XSD::XSD_attribute {
#       @name = "name"
#       @internal_name = "name"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#     XSD::XSD_attribute {
#       @name = "ref"
#       @internal_name = "ref"
#       @type = "xsd:string"
#       @use = nil
#       @ref = nil
#     }
#   ]
#   @sequence = [
#     XSD::XSD_sequence {
#       @maxOccurs = 1
#       @internal_name = "_anon19"
#       @minOccurs = 1
#       @members = [
#         XSD::XSD_element {
#           @maxOccurs = nil
#           @name = "annotation"
#           @name_ns = "http://www.w3.org/2001/XMLSchema"
#           @internal_name = "annotation"
#           @minOccurs = 0
#           @type = "annotationType"
#           @type_local = "annotationType"
#           @type_ns = "http://www.w3.org/2001/XMLSchema"
#           @ref = nil
#         }
#         XSD::XSD_choice {
#           @maxOccurs = nil
#           @minOccurs = 0
#           @internal_member_name = "choice"
#           @internal_class_name = "_anon20"
#           @element = [
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "attribute"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "attribute"
#               @minOccurs = 1
#               @type = "attributeType"
#               @type_local = "attributeType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#             XSD::XSD_element {
#               @maxOccurs = 1
#               @name = "attributeGroup"
#               @name_ns = "http://www.w3.org/2001/XMLSchema"
#               @internal_name = "attributeGroup"
#               @minOccurs = 1
#               @type = "attributeGroupType"
#               @type_local = "attributeGroupType"
#               @type_ns = "http://www.w3.org/2001/XMLSchema"
#               @ref = nil
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }
class ComplexType_attributeGroupType < Base
  attr_accessor :xml_src_node
  # Attribute <code>name</code> (optional, might be +nil+)
  attr_accessor :name
  # Attribute <code>ref</code> (optional, might be +nil+)
  attr_accessor :ref
  # For internal use
  attr_writer :_sequence # the sequence object
  # Child element getter
  def annotation; @_sequence.annotation end
  # Child element setter
  def annotation=(value); @_sequence.annotation(value) end
  # Child element getter
  def choice; @_sequence.choice end
  # Child element setter
  def choice=(value); @_sequence.choice(value) end
  def initialize
    super()
    @name = nil
    @ref = nil
  end
  # Serialize as XML.
  # The +ename+ (+String+) is used as the element name and the
  # XML is written to +out+ (+IO+) with indenting of +indent+.
  def xml(ename, out, indent='')
    out.print "#{indent}<#{ename}" # start tag
    if @name
      out.print " name=\"#{XSD.pcdata(@name)}\""
    end
    if @ref
      out.print " ref=\"#{XSD.pcdata(@ref)}\""
    end
    out.print ">"
    out.puts
    @_sequence.xml(out, indent)
    out.print indent
    out.print "</#{ename}>\n" # end tag
  end

end # class ComplexType_attributeGroupType


   # Exception that is raised if the XML violates the XML Schema.
   class InvalidXMLError < Exception; end

   #----------------
   # Methods used in the output of XML

   private

   # Returns a copy of +str+ with the ampersand, greater than and
   # less than characters replaced by XML character entities. The
   # result is suitable for output as XML *character data*.
   def self.cdata(str)
     s = str.gsub('&', '&amp;')
     s.gsub!('<', '&lt;')
     s.gsub!('>', '&gt;')
     s
   end

   # Returns a copy of +str+ with the ampersand, greater than, less
   # than, double and single quotes characters replaced by XML
   # character entities. The result is suitable for output as the
   # value of an XML attribute.
   def self.pcdata(str)
     s = str.gsub('&', '&amp;')
     s.gsub!('<', '&lt;')
     s.gsub!('>', '&gt;')
     s.gsub!('\'', '&apos;')
     s.gsub!('"', '&quot;')
     s
   end

   #----------------
   # Methods used to parse XML

    private

    # Parses XML from the +src+ into a REXML::Document.
    #
    # This method is used by all the externally invoked parsing methods
    # to convert its source (a +File+ or +String+) into a tree of objects.

    def self.src_to_dom(src)
      if src.is_a? REXML::Element
        return src
      elsif src.is_a? File
        return REXML::Document.new(src).root
      elsif src.is_a? String
        return REXML::Document.new(src).root
      else
        e = ArgumentError.new "#{__method__} expects a File, String or REXML::Element"
        e.set_backtrace caller # TODO: fix level of nesting reported
        raise e
      end
    end # def self.src_to_dom

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

    # Parses the +node+ for character data content. Assumes the +node+
    # is an REXML::Element object. Returns a +String+ or raises
    # an exception if the element does not just contain character data.
    def self.parse_primitive_string(node)
      # Parse element containing just text

      value = ''
      node.each_child do |child|
        if child.is_a?(REXML::Element)
          raise InvalidXMLError, "Unexpected element:"           " {#{child.namespace}}#{child.name}"

        elsif child.is_a?(REXML::Text)
          value << REXML::Text.unnormalize(child.to_s)

        elsif child.is_a?(REXML::Comment)
          # Ignore comments

        else
          raise InvalidXMLError, "Unknown node type: #{child.class}"
        end
      end
      value
    end # def parse_text

    # Parses an empty element. Such elements contain no attributes
    # and no content model.
    def self.parse_empty(node)
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

    # Checks if the +node+ represents an element with the given
    # +element_name+. Assumes that the +node+ is an
    # +REXML::element+ object. Raises an exception if it is not.
    def self.expecting_element(element_name, node)

      if node.name != element_name || node.namespace != XSD::NAMESPACE
        raise InvalidXMLError, "Unexpected element:"         " expecting {#{XSD::NAMESPACE}}#{element_name}:"         " got {#{node.namespace}}#{node.name}"
      end

    end

    # Checks if the +node+ contains just whitespace text. Assumes that
    # the +node+ is a +REXML::Text+ object. Raises an exception there are
    # non-whitespace characters in the text.
    def self.expecting_whitespace(node)
      if node.to_s !~ /^ *$/
        raise InvalidXMLError, "Unexpected text: #{node.to_s.strip}"
      end
    end

#================================================================
# Parse explicitly identified element methods

# Parser for choice: <code>_anon2</code>

def self.parse_choice__anon2(nodes, offset)
  # Create result object
  result = XSD::Choice__anon2.new

  # Parse choice
  while offset < nodes.length do
    node = nodes[offset]
    if node.is_a?(REXML::Element)
      if node.name == 'annotation' && node.namespace == NAMESPACE
        result.annotation = parse_complexType_annotationType(node)
        return result, offset + 1
      elsif node.name == 'include' && node.namespace == NAMESPACE
        result.include = parse_complexType_includeType(node)
        return result, offset + 1
      elsif node.name == 'import' && node.namespace == NAMESPACE
        result.import = parse_complexType_importType(node)
        return result, offset + 1
      else
        raise InvalidXMLError, "Unexpected element in choice: {#{node.namespace}}#{node.name}"
      end

    elsif node.is_a?(REXML::Text)
      expecting_whitespace node
      offset += 1
    elsif node.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "Unknown node type: #{child.class}"
    end
  end # while
  raise 'choice not found'
end

# Parser for choice: <code>_anon3</code>

def self.parse_choice__anon3(nodes, offset)
  # Create result object
  result = XSD::Choice__anon3.new

  # Parse choice
  while offset < nodes.length do
    node = nodes[offset]
    if node.is_a?(REXML::Element)
      if node.name == 'annotation' && node.namespace == NAMESPACE
        result.annotation = parse_complexType_annotationType(node)
        return result, offset + 1
      elsif node.name == 'element' && node.namespace == NAMESPACE
        result.element = parse_complexType_elementType(node)
        return result, offset + 1
      elsif node.name == 'attribute' && node.namespace == NAMESPACE
        result.attribute = parse_complexType_attributeType(node)
        return result, offset + 1
      elsif node.name == 'simpleType' && node.namespace == NAMESPACE
        result.simpleType = parse_complexType_simpleTypeType(node)
        return result, offset + 1
      elsif node.name == 'complexType' && node.namespace == NAMESPACE
        result.complexType = parse_complexType_complexTypeType(node)
        return result, offset + 1
      elsif node.name == 'attributeGroup' && node.namespace == NAMESPACE
        result.attributeGroup = parse_complexType_attributeGroupType(node)
        return result, offset + 1
      else
        raise InvalidXMLError, "Unexpected element in choice: {#{node.namespace}}#{node.name}"
      end

    elsif node.is_a?(REXML::Text)
      expecting_whitespace node
      offset += 1
    elsif node.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "Unknown node type: #{child.class}"
    end
  end # while
  raise 'choice not found'
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon1(nodes, offset)

  result = Sequence__anon1.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if Choice__anon2.match(child)
          r, offset = parse_choice__anon2(nodes, offset)
          result.choice1 << r
        else
          state = 1
        end
      when 1
        if Choice__anon3.match(child)
          r, offset = parse_choice__anon3(nodes, offset)
          result.choice2 << r
        else
          state = 2
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check: not required, because all members are minOccurs=0

  # Success
  return [result, offset]
end

# Parser for complexType: <code>schemaType</code>

def self.parse_complexType_schemaType(node)

  # Create result object
  result = XSD::ComplexType_schemaType.new
  result.xml_src_node = node

  # Parse attributes
  result.version = attr_optional(node, 'version')
  result.targetNamespace = attr_optional(node, 'targetNamespace')
  result.elementFormDefault = attr_optional(node, 'elementFormDefault')
  result.attributeFormDefault = attr_optional(node, 'attributeFormDefault')
  result.lang = attr_optional(node, 'lang')
  # Content model
  result._sequence, offset = parse_sequence__anon1(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon4(nodes, offset)

  result = Sequence__anon4.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'documentation' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_documentationType(nodes[offset]), offset + 1
          result.documentation << r
        else
          state = 1
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check: not required, because all members are minOccurs=0

  # Success
  return [result, offset]
end

# Parser for complexType: <code>annotationType</code>

def self.parse_complexType_annotationType(node)

  # Create result object
  result = XSD::ComplexType_annotationType.new
  result.xml_src_node = node

  # Parse attributes
  result.lang = attr_optional(node, 'lang')
  # Content model
  result._sequence, offset = parse_sequence__anon4(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for complexType: <code>documentationType</code>

def self.parse_complexType_documentationType(node)

  # Create result object
  result = XSD::ComplexType_documentationType.new
  result.xml_src_node = node

  # Content model
  begin # extension parsing
    # Parse extension's attributes
  result.source = attr_optional(node, 'source')
  result.lang = attr_optional(node, 'lang')

    # Parse extension's base
    result._value = parse_primitive_string(node)
  end # extension parsing

  # Success
  result
end

# Parser for complexType: <code>includeType</code>

def self.parse_complexType_includeType(node)

  # Create result object
  result = XSD::ComplexType_includeType.new
  result.xml_src_node = node

  # Parse attributes
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
  end # while

  # Success
  result
end

# Parser for complexType: <code>importType</code>

def self.parse_complexType_importType(node)

  # Create result object
  result = XSD::ComplexType_importType.new
  result.xml_src_node = node

  # Parse attributes
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
  end # while

  # Success
  result
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon5(nodes, offset)

  result = Sequence__anon5.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'extension' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_extensionType(nodes[offset]), offset + 1
          result.extension = r
        else
          raise InvalidXMLError, "sequence not enough extension" if result.extension == nil
          state = 1
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check
  if result.extension == nil
    raise InvalidXMLError, "sequence is incomplete"
  end

  # Success
  return [result, offset]
end

# Parser for complexType: <code>simpleContentType</code>

def self.parse_complexType_simpleContentType(node)

  # Create result object
  result = XSD::ComplexType_simpleContentType.new
  result.xml_src_node = node

  # Content model
  result._sequence, offset = parse_sequence__anon5(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon6(nodes, offset)

  result = Sequence__anon6.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'attribute' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_attributeType(nodes[offset]), offset + 1
          result.attribute << r
        else
          raise InvalidXMLError, "sequence not enough attribute" if result.attribute.length < 1
          state = 1
        end
      when 1
        if child.name == 'annotation' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_annotationType(nodes[offset]), offset + 1
          result.annotation << r
        else
          state = 2
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check
  if result.attribute.length < 1
    raise InvalidXMLError, "sequence is incomplete"
  end

  # Success
  return [result, offset]
end

# Parser for complexType: <code>extensionType</code>

def self.parse_complexType_extensionType(node)

  # Create result object
  result = XSD::ComplexType_extensionType.new
  result.xml_src_node = node

  # Parse attributes
  result.base = attr_required(node, 'base')
  # Content model
  result._sequence, offset = parse_sequence__anon6(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for choice: <code>_anon8</code>

def self.parse_choice__anon8(nodes, offset)
  # Create result object
  result = XSD::Choice__anon8.new

  # Parse choice
  while offset < nodes.length do
    node = nodes[offset]
    if node.is_a?(REXML::Element)
      if node.name == 'complexType' && node.namespace == NAMESPACE
        result.complexType = parse_complexType_complexTypeType(node)
        return result, offset + 1
      else
        raise InvalidXMLError, "Unexpected element in choice: {#{node.namespace}}#{node.name}"
      end

    elsif node.is_a?(REXML::Text)
      expecting_whitespace node
      offset += 1
    elsif node.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "Unknown node type: #{child.class}"
    end
  end # while
  raise 'choice not found'
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon7(nodes, offset)

  result = Sequence__anon7.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'annotation' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_annotationType(nodes[offset]), offset + 1
          result.annotation << r
        else
          state = 1
        end
      when 1
        if Choice__anon8.match(child)
          r, offset = parse_choice__anon8(nodes, offset)
          result.choice = r
        else
          state = 2
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check: not required, because all members are minOccurs=0

  # Success
  return [result, offset]
end

# Parser for complexType: <code>elementType</code>

def self.parse_complexType_elementType(node)

  # Create result object
  result = XSD::ComplexType_elementType.new
  result.xml_src_node = node

  # Parse attributes
  result.name = attr_optional(node, 'name')
  result.type_attribute = attr_optional(node, 'type')
  result.minOccurs = attr_optional(node, 'minOccurs')
  result.maxOccurs = attr_optional(node, 'maxOccurs')
  result.ref = attr_optional(node, 'ref')
  # Content model
  result._sequence, offset = parse_sequence__anon7(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for complexType: <code>enumerationType</code>

def self.parse_complexType_enumerationType(node)

  # Create result object
  result = XSD::ComplexType_enumerationType.new
  result.xml_src_node = node

  # Content model
  begin # extension parsing
    # Parse extension's attributes
  result.value = attr_optional(node, 'value')

    # Parse extension's base
    result._value = parse_primitive_string(node)
  end # extension parsing

  # Success
  result
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon9(nodes, offset)

  result = Sequence__anon9.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'enumeration' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_enumerationType(nodes[offset]), offset + 1
          result.enumeration << r
        else
          state = 1
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check: not required, because all members are minOccurs=0

  # Success
  return [result, offset]
end

# Parser for complexType: <code>restrictionType</code>

def self.parse_complexType_restrictionType(node)

  # Create result object
  result = XSD::ComplexType_restrictionType.new
  result.xml_src_node = node

  # Parse attributes
  result.base = attr_optional(node, 'base')
  # Content model
  result._sequence, offset = parse_sequence__anon9(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon10(nodes, offset)

  result = Sequence__anon10.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'restriction' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_restrictionType(nodes[offset]), offset + 1
          result.restriction = r
        else
          raise InvalidXMLError, "sequence not enough restriction" if result.restriction == nil
          state = 1
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check
  if result.restriction == nil
    raise InvalidXMLError, "sequence is incomplete"
  end

  # Success
  return [result, offset]
end

# Parser for complexType: <code>simpleTypeType</code>

def self.parse_complexType_simpleTypeType(node)

  # Create result object
  result = XSD::ComplexType_simpleTypeType.new
  result.xml_src_node = node

  # Content model
  result._sequence, offset = parse_sequence__anon10(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for choice: <code>_anon12</code>

def self.parse_choice__anon12(nodes, offset)
  # Create result object
  result = XSD::Choice__anon12.new

  # Parse choice
  while offset < nodes.length do
    node = nodes[offset]
    if node.is_a?(REXML::Element)
      if node.name == 'simpleContent' && node.namespace == NAMESPACE
        result.simpleContent = parse_complexType_simpleContentType(node)
        return result, offset + 1
      elsif node.name == 'sequence' && node.namespace == NAMESPACE
        result.sequence = parse_complexType_sequenceType(node)
        return result, offset + 1
      elsif node.name == 'choice' && node.namespace == NAMESPACE
        result.choice = parse_complexType_choiceType(node)
        return result, offset + 1
      else
        raise InvalidXMLError, "Unexpected element in choice: {#{node.namespace}}#{node.name}"
      end

    elsif node.is_a?(REXML::Text)
      expecting_whitespace node
      offset += 1
    elsif node.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "Unknown node type: #{child.class}"
    end
  end # while
  raise 'choice not found'
end

# Parser for choice: <code>_anon13</code>

def self.parse_choice__anon13(nodes, offset)
  # Create result object
  result = XSD::Choice__anon13.new

  # Parse choice
  while offset < nodes.length do
    node = nodes[offset]
    if node.is_a?(REXML::Element)
      if node.name == 'attribute' && node.namespace == NAMESPACE
        result.attribute = parse_complexType_attributeType(node)
        return result, offset + 1
      elsif node.name == 'attributeGroup' && node.namespace == NAMESPACE
        result.attributeGroup = parse_complexType_attributeGroupType(node)
        return result, offset + 1
      else
        raise InvalidXMLError, "Unexpected element in choice: {#{node.namespace}}#{node.name}"
      end

    elsif node.is_a?(REXML::Text)
      expecting_whitespace node
      offset += 1
    elsif node.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "Unknown node type: #{child.class}"
    end
  end # while
  raise 'choice not found'
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon11(nodes, offset)

  result = Sequence__anon11.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'annotation' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_annotationType(nodes[offset]), offset + 1
          result.annotation << r
        else
          state = 1
        end
      when 1
        if Choice__anon12.match(child)
          r, offset = parse_choice__anon12(nodes, offset)
          result.choice1 = r
        else
          state = 2
        end
      when 2
        if Choice__anon13.match(child)
          r, offset = parse_choice__anon13(nodes, offset)
          result.choice2 << r
        else
          state = 3
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check: not required, because all members are minOccurs=0

  # Success
  return [result, offset]
end

# Parser for complexType: <code>complexTypeType</code>

def self.parse_complexType_complexTypeType(node)

  # Create result object
  result = XSD::ComplexType_complexTypeType.new
  result.xml_src_node = node

  # Parse attributes
  result.name = attr_optional(node, 'name')
  # Content model
  result._sequence, offset = parse_sequence__anon11(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for choice: <code>_anon15</code>

def self.parse_choice__anon15(nodes, offset)
  # Create result object
  result = XSD::Choice__anon15.new

  # Parse choice
  while offset < nodes.length do
    node = nodes[offset]
    if node.is_a?(REXML::Element)
      if node.name == 'element' && node.namespace == NAMESPACE
        result.element = parse_complexType_elementType(node)
        return result, offset + 1
      elsif node.name == 'sequence' && node.namespace == NAMESPACE
        result.sequence = parse_complexType_sequenceType(node)
        return result, offset + 1
      elsif node.name == 'choice' && node.namespace == NAMESPACE
        result.choice = parse_complexType_choiceType(node)
        return result, offset + 1
      else
        raise InvalidXMLError, "Unexpected element in choice: {#{node.namespace}}#{node.name}"
      end

    elsif node.is_a?(REXML::Text)
      expecting_whitespace node
      offset += 1
    elsif node.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "Unknown node type: #{child.class}"
    end
  end # while
  raise 'choice not found'
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon14(nodes, offset)

  result = Sequence__anon14.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'annotation' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_annotationType(nodes[offset]), offset + 1
          result.annotation << r
        else
          state = 1
        end
      when 1
        if Choice__anon15.match(child)
          r, offset = parse_choice__anon15(nodes, offset)
          result.choice << r
        else
          raise InvalidXMLError, "sequence not enough choice" if result.choice.length < 1
          state = 2
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check
  if result.choice == nil
    raise InvalidXMLError, "sequence is incomplete"
  end

  # Success
  return [result, offset]
end

# Parser for complexType: <code>sequenceType</code>

def self.parse_complexType_sequenceType(node)

  # Create result object
  result = XSD::ComplexType_sequenceType.new
  result.xml_src_node = node

  # Content model
  result._sequence, offset = parse_sequence__anon14(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for choice: <code>_anon17</code>

def self.parse_choice__anon17(nodes, offset)
  # Create result object
  result = XSD::Choice__anon17.new

  # Parse choice
  while offset < nodes.length do
    node = nodes[offset]
    if node.is_a?(REXML::Element)
      if node.name == 'element' && node.namespace == NAMESPACE
        result.element = parse_complexType_elementType(node)
        return result, offset + 1
      elsif node.name == 'sequence' && node.namespace == NAMESPACE
        result.sequence = parse_complexType_sequenceType(node)
        return result, offset + 1
      elsif node.name == 'choice' && node.namespace == NAMESPACE
        result.choice = parse_complexType_choiceType(node)
        return result, offset + 1
      else
        raise InvalidXMLError, "Unexpected element in choice: {#{node.namespace}}#{node.name}"
      end

    elsif node.is_a?(REXML::Text)
      expecting_whitespace node
      offset += 1
    elsif node.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "Unknown node type: #{child.class}"
    end
  end # while
  raise 'choice not found'
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon16(nodes, offset)

  result = Sequence__anon16.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'annotation' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_annotationType(nodes[offset]), offset + 1
          result.annotation << r
        else
          state = 1
        end
      when 1
        if Choice__anon17.match(child)
          r, offset = parse_choice__anon17(nodes, offset)
          result.choice << r
        else
          raise InvalidXMLError, "sequence not enough choice" if result.choice.length < 1
          state = 2
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check
  if result.choice == nil
    raise InvalidXMLError, "sequence is incomplete"
  end

  # Success
  return [result, offset]
end

# Parser for complexType: <code>choiceType</code>

def self.parse_complexType_choiceType(node)

  # Create result object
  result = XSD::ComplexType_choiceType.new
  result.xml_src_node = node

  # Parse attributes
  result.minOccurs = attr_optional(node, 'minOccurs')
  result.maxOccurs = attr_optional(node, 'maxOccurs')
  # Content model
  result._sequence, offset = parse_sequence__anon16(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon18(nodes, offset)

  result = Sequence__anon18.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'annotation' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_annotationType(nodes[offset]), offset + 1
          result.annotation << r
        else
          state = 1
        end
      when 1
        if child.name == 'simpleType' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_simpleTypeType(nodes[offset]), offset + 1
          result.simpleType = r
        else
          state = 2
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check: not required, because all members are minOccurs=0

  # Success
  return [result, offset]
end

# Parser for complexType: <code>attributeType</code>

def self.parse_complexType_attributeType(node)

  # Create result object
  result = XSD::ComplexType_attributeType.new
  result.xml_src_node = node

  # Parse attributes
  result.name = attr_optional(node, 'name')
  result.type_attribute = attr_optional(node, 'type')
  result.ref = attr_optional(node, 'ref')
  result.use = attr_optional(node, 'use')
  # Content model
  result._sequence, offset = parse_sequence__anon18(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for choice: <code>_anon20</code>

def self.parse_choice__anon20(nodes, offset)
  # Create result object
  result = XSD::Choice__anon20.new

  # Parse choice
  while offset < nodes.length do
    node = nodes[offset]
    if node.is_a?(REXML::Element)
      if node.name == 'attribute' && node.namespace == NAMESPACE
        result.attribute = parse_complexType_attributeType(node)
        return result, offset + 1
      elsif node.name == 'attributeGroup' && node.namespace == NAMESPACE
        result.attributeGroup = parse_complexType_attributeGroupType(node)
        return result, offset + 1
      else
        raise InvalidXMLError, "Unexpected element in choice: {#{node.namespace}}#{node.name}"
      end

    elsif node.is_a?(REXML::Text)
      expecting_whitespace node
      offset += 1
    elsif node.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "Unknown node type: #{child.class}"
    end
  end # while
  raise 'choice not found'
end

# Parser for a sequence.
# Starting at the +offset+ node in the +nodes+ array.
# Returns matched object and next offset index after parsed nodes.
def self.parse_sequence__anon19(nodes, offset)

  result = Sequence__anon19.new

  # Parse sequence
  state = 0
  while offset < nodes.size
    child = nodes[offset]

    if child.is_a?(REXML::Element)
      case state
      when 0
        if child.name == 'annotation' && child.namespace == XSD::NAMESPACE
          r, offset = parse_complexType_annotationType(nodes[offset]), offset + 1
          result.annotation << r
        else
          state = 1
        end
      when 1
        if Choice__anon20.match(child)
          r, offset = parse_choice__anon20(nodes, offset)
          result.choice << r
        else
          state = 2
        end
      else
        raise InvalidXMLError, "unexpected element: {#{child.namespace}}#{child.name}"
      end # case state
    elsif child.is_a?(REXML::Text)
      expecting_whitespace child
      offset += 1
    elsif child.is_a?(REXML::Comment)
      # Ignore comments
      offset += 1
    else
      raise InvalidXMLError, "internal error: unsupported node type: #{child.class}"
    end
  end # while

  # Completeness check: not required, because all members are minOccurs=0

  # Success
  return [result, offset]
end

# Parser for complexType: <code>attributeGroupType</code>

def self.parse_complexType_attributeGroupType(node)

  # Create result object
  result = XSD::ComplexType_attributeGroupType.new
  result.xml_src_node = node

  # Parse attributes
  result.name = attr_optional(node, 'name')
  result.ref = attr_optional(node, 'ref')
  # Content model
  result._sequence, offset = parse_sequence__anon19(node.children, 0)
  if offset < node.children.size
     raise "complexType sequence has left over elements"
  end

  # Success
  result
end

# Parser for top level element +schema+
def self.parse_element_schema(src)
  root = src_to_dom src

  expecting_element 'schema', root
  parse_complexType_schemaType(root) # type
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
def self.parse(src)
  root = src_to_dom(src)

  # Try to parse any of the known top level elements
  if root.name == 'schema'
    return [ parse_element_schema(root), 'schema' ]
  else
    raise "could not parse any known element"
  end
end

end # module XSD

#EOF
