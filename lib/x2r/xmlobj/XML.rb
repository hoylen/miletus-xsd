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
#   obj, name = XML.parser(src)
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

module XML

# Target XML namespace for this module.
NAMESPACE='http://www.w3.org/XML/1998/namespace'

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

      if node.name != element_name || node.namespace != XML::NAMESPACE
        raise InvalidXMLError, "Unexpected element:"         " expecting {#{XML::NAMESPACE}}#{element_name}:"         " got {#{node.namespace}}#{node.name}"
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

# Parser for attributeGroup: specialAttrs
def self.parse_attributeGroup_specialAttrs(node, result)
  result.xml:base = attr_optional(node, 'xml:base')
  result.lang = attr_optional(node, 'lang')
  result.xml:space = attr_optional(node, 'xml:space')
  result.xml:id = attr_optional(node, 'xml:id')
end

end # module XML

#EOF
