#!/usr/bin/ruby -w

# Implementation of XML Schema primitives types.
#
# This is used by the the generated Ruby code.

module XSDPrimitives

  def self.parse_string(node)

    # Parses the +node+ for character data content. Assumes the +node+
    # is an REXML::Element object. Returns a +String+ or raises
    # an exception if the element does not just contain character data.

    # Parse element containing just text

    value = ''
    node.each_child do |child|
      if child.is_a?(REXML::Element)
        raise InvalidXMLError, "Unexpected element:" \
        " {#{child.namespace}}#{child.name}"

      elsif child.is_a?(REXML::Text)
        value << REXML::Text.unnormalize(child.to_s)

      elsif child.is_a?(REXML::Comment)
        # Ignore comments

      else
        raise InvalidXMLError, "Unknown node type: #{child.class}"
      end
    end
    value
  end


  # Parses an empty element. Such elements contain no attributes
  # and no content model.

  def self.parse_empty_content_model(node)
    # TODO: check for no attributes

    node.each_child do |child|
      if child.is_a?(REXML::Element)
        raise InvalidXMLError, "unexpected element in empty content model: {\#{child.namespace}}\#{child.name}"
      elsif child.is_a?(REXML::Text)
        expecting_whitespace child
      elsif child.is_a?(REXML::Comment)
        # Ignore comments
      else
        raise InvalidXMLError, "unknown node type: \#{child.class}"
      end
    end

  end

  # Checks if the +node+ contains just whitespace text. Assumes that
  # the +node+ is a +REXML::Text+ object. Raises an exception there are
  # non-whitespace characters in the text.
  def self.expecting_whitespace(node)
    if node.to_s !~ /^\s*$/
      raise InvalidXMLError, "Unexpected text: \#{node.to_s.strip}"
    end
  end

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

  # Output a primitive value

  def self.primitive_to_xml(ns, ename, i, indent, io)
    if indent
      io.print indent
    end
    io.print "<#{ename}>"
    io.print cdata(i)
    io.puts "</#{ename}>"
  end

end

#EOF
