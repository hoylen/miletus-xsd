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

end

#EOF
