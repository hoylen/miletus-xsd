#!/usr/bin/ruby -w
# :title: xsd-to-ruby.rb
# = XML Schema to Ruby compiler
#

require 'optparse'

#================================================================

# Module containing classes to represent XML Schema components.

module XSD

  # Note: it is not possible to simply use the name of the components
  # as class names, because Ruby class names must begin with a capital
  # letter and the component names cannot be guaranteed to do that.

  # Constants used to generate class names.
  PREFIX_CLASS_CT = 'ComplexType_'
  PREFIX_CLASS_SE = 'Sequence_'
  PREFIX_CLASS_CH = 'Choice_'
  PREFIX_CLASS_CH_OPTION = 'ChoiceOption_'

  # Constants used to make member names unique

  SUFFIX_MEMBER_AT = '_attribute'
  SUFFIX_MEMBER_EL = '_element'

  # Constants used to generate parsing method names.

  PREFIX_PARSE_PR = 'parse_primitive_'
  PREFIX_PARSE_AG = 'parse_attributeGroup_'
  PREFIX_PARSE_EL = 'parse_element_'
  PREFIX_PARSE_CT = 'parse_complexType_'
  PREFIX_PARSE_SE = 'parse_sequence_'
  PREFIX_PARSE_CH = 'parse_choice_'

  #----------------------------------------------------------------

  def self.lookup_QName(context, qname)
    a, b = qname.split(':')
    if b
      # a=prefix; b=localname
      [ ns_prefix_mapping_hack(context, a), b ]
    else
      # a=localname (in current namespace)
      [ context.current.namespace, a ]
    end
  end

  def self.ns_prefix_mapping_hack(context, prefix)
    # This is a hack. This should be replaced by the real prefixes
    # determined when parsing the XML Schema.

    case prefix
    when nil
      context.current.namespace
    when 'xsd'
      'http://www.w3.org/2001/XMLSchema'
    when 'xs'
      'http://www.w3.org/2001/XMLSchema'
    when 'xml'
      'http://www.w3.org/XML/1998/namespace'
    else
      raise "internal error: namespace prefix not supported yet: #{prefix}"
    end
  end

  # Base class for all XML Schema objects.
  class Base
    def initialize
      super()
      @children = Array.new
    end

    # Append an object to this object's content model. This is a interim
    # construction method for the schema model, until this is
    # implemented using a real XML Schema parser.
    def <<(other)
      classname = other.class.to_s
      if classname =~ /^XSD::XSD_/
        classname.sub!(/^XSD::XSD_/, '')
        member = self.instance_variable_get("@#{classname}")
        if ! member
          raise "instance variable not found in #{self.class.to_s}: #{classname}"
        end
        member << other
      else
        raise "unexpected class name: #{classname}"
      end
    end

    def to_str(indent='')

      # Determine the attributes (singular values) and elements (array values)

      attrs = []
      elems = []
      self.instance_variables.each do |sym|
        var = self.instance_variable_get(sym)
        if var.class == Array
          elems << sym
        else
          attrs << sym
        end
      end

      # Class and attributes

      s = ''
      s << indent << self.class.to_s << " {\n"
      attrs.each do |sym|
        var = self.instance_variable_get(sym)

        s << indent << "  #{sym} = "

        if var == nil
          s << 'nil'
        elsif var.is_a? String
          s << '"' << var << '"'
        elsif var.is_a? Integer
          s << var.to_s
        else
          s << var
        end
        s << "\n"
      end

      # Elements

      elems.each do |sym|
        var = self.instance_variable_get(sym)
        if 0 < var.length
          s << indent << "  #{sym} = [\n"
          var.each do |m|
            s << m.to_str(indent + '    ')
          end
          s << indent << "  ]\n"
        end
      end
      s << indent << "}\n"
    end
  end

  #----------------------------------------------------------------

  # XML Schema import
  class XSD_import < Base
    attr_accessor :schemaLocation
    attr_accessor :namespace
  end

  #----------------------------------------------------------------

  # XML Schema include
  class XSD_include < Base
    attr_accessor :schemaLocation
  end

  #----------------------------------------------------------------

  # XML Schema attribute
  class XSD_attribute < Base

    # Either 'optional', 'required' or nil (nil means optional)
    attr_accessor :use

    # Datatype of the attribute (cannot be used with +simpleType+ or +ref+)
    attr_accessor :type

    # Name of the attribute (used with +type+)
    attr_accessor :name

    # Reference to an attribute declaration (not supported yet)
    attr_accessor :ref

    # Definition of the datatype of the attribute (cannot be used when
    # +type+ (and +name+) is used)
    attr_accessor :simpleType

    # Constructor
    def initialize
      super()
      @use = nil
      @type = nil
      @name = nil
      @ref = nil
      @simpleType = []
    end

    def ncname_to_attribute_method_name(ncname)
      # Convert an attribute's name into a suitable method name.

      # The name of an attribute is xs:NCName, which is a non-colonized name.
      # From <http://www.w3.org/TR/1999/REC-xml-names-19990114/>:
      #   NCName ::= (Letter | '_') (NCNameChar)*
      #   NCNameChar ::= Letter | Digit | '.' | '-' | '_' | CombiningChar | Extender
      #
      # Ruby methods names, by convention should start with a capital letter, but
      # for consistency with name of the attribute, this convention will not be
      # followed.

      method_name = ncname.gsub(/\-\./, '_') # convert hyphens and full stops to underscore

      if ! Object.method_defined? method_name
        # No clash. Use the attribute local name as the accessor name
        method_name
      else
        # The name of this attribute will clash with an existing
        # method on the Object class. So use a different name for the
        # attribute.
        "#{method_name}#{SUFFIX_MEMBER_AT}"
      end
    end

    def fix_names(context)
      if @name
        @internal_name = ncname_to_attribute_method_name(@name)
      end
    end

    def gen_accessor(context, attr_group_name=nil)

      print "  # Attribute <code>#{@name}</code>"
      if attr_group_name
        print " from the attribute group <code>#{attr_group_name}</code>"
      end
      if @use == nil ||  @use == 'optional'
        puts " (optional, might be +nil+)"
      else
        puts " (required, always has a value)"
      end

      if @name
        # Named attribute
        puts "  attr_accessor :#{@internal_name}"

      elsif @ref
        # Referenced attribute
        if @ref == 'xml:lang'
          puts "  attr_accessor :lang"
        else
          raise "  # TODO: ref attribute not supported yet: #{attr.ref}"
        end
      else
        raise "unexpected form for attribute"
      end
    end # def gen_accessors

    def gen_parser(context, node_name, result_name)

      if @name
        aname = @name
        member_name = @internal_name
      elsif @ref
        if @ref == 'xml:lang'
          aname = 'lang' # FIXME
          member_name = 'lang'
        else
          aname = @ref # FIXME
          member_name = @ref # FIXME
        end
      else
        raise "attribute without a name or a ref"
      end

      if @use == nil || @use == 'optional'
        puts "  #{result_name}.#{member_name} = attr_optional(#{node_name}, '#{aname}')"
      elsif use == 'required'
        puts "  #{result_name}.#{member_name} = attr_required(#{node_name}, '#{aname}')"
      else
        raise "TODO"
      end
    end

    def gen_xml(module_name)

      if @name
        aname = @name
        iname = @internal_name
      elsif @ref
        if @ref == 'xml:lang'
          aname = 'xsd:lang' # FIXME
          iname = 'lang' # FIXME
        else
          aname = @ref
          iname = 'foobar' # FIXME
        end
      else
        raise 'internal error'
      end

      puts "    if @#{iname}"
      puts "      out.print \" #{aname}=\\\"\#{#{module_name}.pcdata(@#{iname})}\\\"\""
      puts "    end"
    end

  end

  #----------------------------------------------------------------

  # This class is currently used to represent both the definitions of an
  # attributeGroup (with +name+ set and a content model containing
  # +attribute+ elements; and no +ref+) and when an attributeGroup is
  # referenced (with +ref+ set; and no +name+ or +attribute+ elements).

  class XSD_attributeGroup < Base
    attr_accessor :name
    attr_accessor :ref
    attr_accessor :attribute
    def initialize
      super()
      @name = nil
      @ref = nil
      @attribute = []
    end

    def fix_names(context)
      if @name
        # Definition of an attribute group
        @internal_name = @name # TODO: make into a symbol
        @attribute.each { |x| x.fix_names(context) }

      elsif @ref != nil
        # Usage of a reference group
        raise 'internal error' if ! @attribute.empty?
        @ref_local, ref_ns_prefix = @ref.split(':')
        @ref_ns = XSD.ns_prefix_mapping_hack(context, ref_ns_prefix) # TODO

      else
        raise 'internal error'
      end
    end

    def gen_accessors(context)
      raise "internal error" if ! @ref

      ag = context.find_attributeGroup(@ref_local, @ref_ns)
      if ! ag
        raise "unknown attributeGroup: #{@ref}"
      end

      ag.attribute.each do |attr|
        attr.gen_accessor(context, ag.name)
      end
    end

    def gen_parser(context)
      puts "  #{PREFIX_PARSE_AG}#{@ref}(node, result)"
    end

    def generate_parser(context)

      puts "# Parser for attributeGroup: #{name}"
      puts "def self.#{PREFIX_PARSE_AG}#{@name}(node, result)"
      attribute.each do |attr|
        attr.gen_parser(context, 'node', 'result')
      end
      puts "end"
      puts
    end
  end

  #----------------------------------------------------------------

  # XML Schema extension
  class XSD_extension < Base
    attr_accessor :base
    attr_accessor :attribute
    def initialize
      super()
      @attribute = []
    end

    def fix_names(context)
      @attribute.each { |x| x.fix_names(context) }
    end

    def gen_accessors(context)

      # Accessors for attributes (if any)

      @attribute.each do |attr|
        attr.gen_accessor(context)
      end

      # Accessor for the value

      puts "  # The simpleContent value as a +String+."
      puts "  # In XML Schema, this is an extension of <code>#{@base}</code>."
      puts "  attr_accessor :_value"
      puts
    end

    def gen_parser(context, node_name, result_name)
      puts "  begin # extension parsing"

      # Parse attributes

      if 0 < @attribute.length
        puts "    # Parse extension's attributes"
        @attribute.each do |attr|
          attr.gen_parser(context, node_name, result_name)
        end
      else
        puts "  # No attributes in extension"
      end
      puts

      # Parse base
      puts "    # Parse extension's base"
      puts "    #{result_name}._value = #{XSD::PREFIX_PARSE_PR}string(#{node_name})"

      puts "  end # extension parsing"
    end

    def gen_xml(module_name)
      puts "  # Serialize as XML"
      puts "  def xml(ename, out, indent)"

      # Start tag

      puts "    out.print \"\#{indent}<\#{ename}\" # start tag for extension"

      @attribute.each do |attr|
        attr.gen_xml(module_name)
      end
      puts "    out.print '>'"

      # The value

      puts "    out.print #{module_name}.cdata(@_value)"

      # End tag

      puts "    out.print \"</\#{ename}>\\n\" # end tag"
      puts "  end # def xml"
      puts
    end # def gen_xml

  end

  #----------------------------------------------------------------

  # XML Schema simpleContent
  #
  # Limitations: this current implementations only supports simpleContent
  # which are defined by an extension.
  class XSD_simpleContent < Base
    attr_accessor :extension
    def initialize
      super()
      @extension = []
    end

    def fix_names(context)
      raise "internal error" if @extension.length != 1
      @extension[0].fix_names(context)
    end

    def gen_accessors(context)
      raise "internal error" if @extension.length != 1
      @extension[0].gen_accessors(context)
    end

    def gen_parser(context, node_name, result_name)
      raise "internal error" if @extension.length != 1
      @extension[0].gen_parser(context, node_name, result_name)
    end

    def gen_xml(module_name)
      raise "internal error" if @extension.length != 1
      @extension[0].gen_xml(module_name)
    end
  end

  #----------------------------------------------------------------

  class XSD_enumeration < Base
    attr_accessor :value
  end

  #----------------------------------------------------------------

  class XSD_restriction < Base
    attr_accessor :base
    attr_accessor :enumeration
    def initialize
      super()
      @enumeration = []
    end
  end

  #----------------------------------------------------------------

  # XML Schema simpleType
  #
  # Limitation: currently only <code>xsd:restriction</code> is supported.
  class XSD_simpleType < Base

    # Array of exactly one XSD::XSD_restriction object
    attr_accessor :restriction

    # Constructor
    def initialize
      super()
      @restriction = []
    end
  end

  #----------------------------------------------------------------

  # This class is the base class of all particles (i.e. XSD::XSD_element,
  # XSD::XSD_sequence and XSD:XSD_choice).
  #
  # This class defines the +minOccurs+ and +maxOccurs+ accessors.
  class XSD_particle < Base

    # Minimum occurances for this particle. An non-zero integer value.
    attr_accessor :minOccurs

    # Maximum occurances for this particle. An non-zero integer value or
    # nil means unbounded.
    attr_accessor :maxOccurs

    def initialize
      super()
    end

    # Convert the +minOccurs+ and +maxOccurs+ from the XML Schema
    # +String+ attribute values to  numbers (or to +nil+ for +maxOccurs+
    # being +unbounded+), or if they are not set (i.e. was +nil+) to the
    # default value of 1.
    def fix_occurs
      if ! instance_variable_defined?(:@minOccurs)
        @minOccurs = 1
      else
        if @minOccurs !~ /^[1-9]\d?$/ && @minOccurs != '0'
          raise "bad minOccurs value: #{@minOccurs}"
        end
        @minOccurs = Integer(@minOccurs)
      end

      if ! instance_variable_defined?(:@maxOccurs)
        @maxOccurs = 1
      else
        if @maxOccurs == 'unbounded'
          @maxOccurs = nil
        else
          if @maxOccurs !~ /^[1-9]\d?$/ && @maxOccurs != '0'
            raise "bad maxOccurs value: #{@maxOccurs}"
          end
          @maxOccurs = Integer(@maxOccurs)
        end
      end
    end

    # Returns +true+ if +maxOccurs+ is +unbounded+ (i.e. after
    # +fix_occurs+ is called, it is +nil+); +false+ otherwise.
    def unbounded?
      @maxOccurs == nil
    end

    # Returns +true+ if multiple occurances of this particle are
    # permitted (i.e. if +maxOccurs+ is greater than 1 or is
    # +unbounded+); +false+ otherwise.
    def multiples?
      @maxOccurs == nil || 1 < @maxOccurs
    end
  end

  #----------------------------------------------------------------

  class XSD_sequence < XSD_particle
    attr_accessor :members
    attr_accessor :internal_name
    def initialize
      super()
      @members = [] # element, choice, sequence
    end
    # Special << method for sequences
    def <<(other)
      @members << other
    end

    def fix_names(context)
      fix_occurs
      @internal_name = context.nextname() # make up an internal name

      # Assign internal names to choices in the sequence (if any).
      # These will be used as accessor names. First determine if there
      # are any xsd:choices in this sequence.  In this first pass: give
      # them all numbered names (e.g. choice1, choice2, choice3, ...)

      choice_count = 0
      last_choice = nil
      @members.each do |member|
        if member.is_a? XSD_choice
          choice_count += 1
          last_choice = member
          member.internal_name = "choice#{choice_count}"
        end
      end

      if choice_count == 1
        # There is only one choice in the sequence, so use the simpler
        # internal name of 'choice' instead of the more cumbersome
        # internal name of 'choice1'.
        last_choice.internal_name = 'choice'
      end

      # Resurse into every member of the sequence and fix their names

      @members.each { |x| x.fix_names(context) }
    end

    def generate_classes(context)

      module_name = context.current.module_name

      # Generate for nested subcomponents

      @members.each { |x| x.generate_classes(context) }

      # Generate for self

      puts "# Class to represent the sequence: #{@internal_name}"
      puts "#"
      puts to_str('# ')
      puts "class #{XSD::PREFIX_CLASS_SE}#{@internal_name}"

      @members.each do |member|
        if member.multiples?
          if member.minOccurs == 0
            puts "  # Optional and repeatable elements represented by an array."
            puts "  # The array could be empty."
          else
            puts "  # Mandatory and repeatable elements represented by an array."
            puts "  # The array always has at least #{member.minOccurs} members."
          end
          if member.maxOccurs
            puts "  # The array has a maximum of #{member.maxOccurs} members."
          end
        else
          if member.minOccurs == 0
            puts "  # Single optional child element."
            puts "  # Value is +nil+ if the element is not present."
          else
            puts "  # Single mandatory child element."
            puts "  # Value is never +nil+."
          end
        end
        puts "  attr_accessor :#{member.internal_name}"
      end
      puts

      # Need an initiailzer
      puts "  def initialize"
      puts "    super()"
      @members.each do |member|
        if member.multiples?
          puts "    @#{member.internal_name} = []"
        else
          puts "    @#{member.internal_name} = nil"
        end
      end
      puts "  end"
      puts

      # XML output method for sequence

      puts "  # Serialize sequence as XML"
      puts "  def xml(out, indent)"
      puts "    indent += '  '"

      @members.each do |member|
        if member.is_a? XSD_element
          # Member is an element

          # Determine the local name and namespace of the element

          if member.type != nil
            # Element defined by a named datatype
            e_local = member.name
            e_ns = member.name_ns
          elsif ! member.complexType.empty?
            # Element defined by an anonymous complexType
            e_local = member.name
            e_ns = member.name_ns
          elsif member.ref != nil
            # Element references another element
            target = context.find_element(member.ref_local, member.ref_ns)
            e_local = target.name
            e_ns = target.name_ns
          else
            raise "internal error"
          end

          # Output code

          if e_ns != context.current.namespace
            raise "not implemented yet" # TODO: support output for XML with multiple namespaces
          end

          if member.multiples?
            puts "    if ! @#{member.internal_name}.empty?"
            if member.is_simple?(context)
              puts "      @#{member.internal_name}.each do |m|"
              puts "        out.print \"\#{indent}<#{e_local}>\#{#{module_name}.cdata(m)}</#{e_local}>\\n\""
              puts "      end"
            else
              puts "      @#{member.internal_name}.each { |m| m.xml('#{e_local}', out, indent) }"
            end

          else
            puts "    if @#{member.internal_name}"
            if member.is_simple?(context)
              puts "      out.print \"\#{indent}<#{e_local}>\#{#{module_name}.cdata(@#{member.internal_name})}</#{e_local}>\\n\""
            else
              puts "      @#{member.internal_name}.xml('#{e_local}', out, indent)"
            end

          end
          puts "    end"

        elsif member.is_a? XSD_choice
          # Member is a choice
          if member.multiples?
            puts "       @#{member.internal_name}.each { |m| m.xml(out, indent) }"
          else
            puts "    if @#{member.internal_name}"
            puts "      @#{member.internal_name}.xml(out, indent)"
            puts "    end"
          end

        else
          raise
        end

      end # @members.each
      puts "  end"
      puts
      puts "end # class #{XSD::PREFIX_CLASS_SE}#{@internal_name}"
      puts
    end

    def generate_parser(context)

      # Generate for nested subcomponents

      @members.each do |x|
        if x.is_a?(XSD_element)
          # For elements, there is only one
          # FIXME
          if 0 < x.complexType.length
            x.complexType[0].generate_parser(context)
          end
        else
          x.generate_parser(context)
        end
      end

      # Generate for self

      puts "# Parser for a sequence."
      puts "# Starting at the +offset+ node in the +nodes+ array."
      puts "# Returns matched object and next offset index after parsed nodes."
      puts "def self.#{XSD::PREFIX_PARSE_SE}#{@internal_name}(nodes, offset)"
      puts
      puts "  # Result object"
      puts "  result = #{XSD::PREFIX_CLASS_SE}#{@internal_name}.new"
      puts
      puts "  # Parse sequence"
      puts "  state = 0"
      puts "  while offset < nodes.size"
      puts "    child = nodes[offset]"

      puts "    case"
      puts "    when child.is_a?(REXML::Element)"
      puts "      case state"
      state_count = 0
      choice_count = 0

      @members.each do |member|

        if member.is_a? XSD_element
          puts "      when #{state_count}"
          puts "        begin"
          puts "          expecting_element '#{member.name}', child"

          puts "        rescue"

          # Checks for minOccurs

          if member.minOccurs != 0
            puts "          # minOccurs check"
            if member.multiples?
              puts "          if #{member.name}.length < #{member.minOccurs}"
            else
              puts "          if #{member.name} == nil"
            end
            puts "            raise InvalidXMLError, \"minOccurs not satisfied: #{member.name}\""
            puts "          end"
          else
            puts "          # minOccurs check: minOccurs=0, so no check required"
          end

          # Checks for maxOccurs

          if member.multiples?
            # Repeatable member

            if member.unbounded?
              # Unbounded maxOccurs
              puts "          # maxOccurs check: unbounded, so no check required"
            else
              # Finite maxOccurs
              puts "          # maxOccurs check"
              puts "       if #{member.maxOccurs} < #{member.name}.length"
              puts "         raise InvalidXMLError, \"MaxOccurs exceeded\""
              puts "       end"
            end
          else
            # Non-repeating member
            puts "          # maxOccurs check???"
            #          if member.minOccurs != 0
            #            puts "          if #{member.name} == nil"
            #            puts "             raise InvalidXMLError, \"Missing element\""
            #            puts "          end"
            #          end
          end

          puts "          state = #{state_count + 1}"
          puts "          repeat"
          puts "        end"

          # Process the element

          print "        result.#{member.name}"
          if member.multiples?
            print ' << '
          else
            print ' = '
          end

          if member.type != nil
            # Element with a named datatype

            if member.type == 'xsd:string'
              puts "#{PREFIX_PARSE_PR}string(child)"
            elsif member.type == 'xsd:anyURI'
              puts "#{PREFIX_PARSE_PR}string(child)"
            else
              puts "#{XSD::PREFIX_PARSE_CT}#{member.type}(child)" # assumes only complexTypes
            end

          elsif ! member.complexType.empty?
            # Element with an anonymous complexType

            the_ct = member.complexType[0]
            puts "#{XSD::PREFIX_PARSE_CT}#{the_ct.internal_name}(child)" # assumes only complexTypes

          elsif member.ref != nil
            raise # TODO

          else
            raise "internal error"
          end

          if member.unbounded?
            puts "        # unbounded: stay in this state"
          else
            # Finite number of occurances
            if member.maxOccurs == 1
              puts "        state = #{state_count + 1} # singular: advance to next state"
            else
              puts "        if #{member.name}.length == #{member.maxOccurs}"
              puts "          state = #{state_count + 1} # maxOccur reached: advance to next state"
              puts "        end"
            end
          end
          puts "      offset += 1"

        elsif member.is_a? XSD_choice
          choice_count += 1
          puts "      when #{state_count}"
          puts "        result.#{member.internal_name}, offset = #{XSD::PREFIX_PARSE_CH}#{member.internal_name}(nodes, offset)"

        elsif member.is_a? XSD_sequence
          # Sequence inside a sequence
          puts "      when #{state_count}"
          puts "      raise \"TODO sequence inside a sequence\""
          puts "      ##  choice#{choice_count}, offset = #{XSD::PREFIX_PARSE_SE}#{member.internal_name}(nodes, offset)"

        else
          raise "TODO: #{@name} expecting only element,choice,sequence in sequence: #{member.class}"
        end

        state_count += 1
      end

      puts "      else"
      puts "        raise InvalidXMLError, \"Unexpected element: {\#{child.namespace}}\#{child.name}\""
      puts "      end # case state"

      puts "    when child.is_a?(REXML::Text)"
      puts "      expecting_whitespace child"
      puts "      offset += 1"
      puts "    when child.is_a?(REXML::Comment)"
      puts "      # Ignore comments"
      puts "      offset += 1"
      puts "    else"
      puts "      raise InvalidXMLError, \"Unknown node type: \#{child.class}\""
      puts "    end"
      puts "  end # while"
      puts

      # Checks for incomplete sequence
      last_required = nil
      @members.each do |member|
        if member.minOccurs != 0
          last_required = member
        end
      end
      if last_required
        # Not everything is optional
        puts "  # Completeness check"
        if last_required.is_a?(XSD_element)
          if last_required.multiples?
            puts "  if result.#{last_required.name}.length < #{last_required.minOccurs}"
          else
            puts "  if result.#{last_required.name} == nil"
          end
          puts "    raise InvalidXMLError, \"sequence is incomplete\""
          puts "  end"
        elsif last_required.is_a?(XSD_choice)
          puts "  if result.#{last_required.internal_name} == nil"
          puts "    raise InvalidXMLError, \"sequence is incomplete\""
          puts "  end"
        elsif last_required.is_a?(XSD_sequence)
          puts "  raise \"TODO: internal error last particle in sequence is a sequence\""
        else
          raise "TODO: last particle in sequence is a #{last_required.class}"
        end
      else
        puts "  # Completeness check: not required, because all members are minOccurs=0"
      end

      puts
      puts "  # Success"
      puts "  return [result, offset]"
      puts "end"
      puts
    end # def generate_parser
  end

  #----------------------------------------------------------------

  # Represents an <code>xsd:choice</code>
  #
  # Currently, choices can only contain <code>xsd:elements</code>

  class XSD_choice < XSD_particle

    # Array of two or more XSD::XSD_element objects.
    attr_accessor :element

    attr_accessor :internal_name

    # Constructor
    def initialize
      super()
      @element = []
    end

    def fix_names(context)
      fix_occurs
      if ! instance_variable_defined?(:@internal_name)
        @internal_name = context.nextname() # make up an internal name
      end

      @element.each { |x| x.fix_names(context) }
    end

    def generate_classes(context)

      # Generate for nested subcomponents

      @element.each { |x| x.generate_classes(context) }

      # Generate for self

      puts "# Class to represent the choice: #{@internal_name}"
      puts "#"
      puts to_str('# ')

      if multiples?
        # Choice that is multivalued
        puts "#"
        puts "# An array of #{XSD::PREFIX_CLASS_CH_OPTION}#{@internal_name}"
        puts "class #{XSD::PREFIX_CLASS_CH}#{@internal_name} < Array"
        puts

        puts "  # Serialize repeatable choices as XML"
        puts "  def xml(out, indent)"
        puts "    self.each { |opt| opt.xml(out, indent) }"
        puts "  end"
        puts

        puts "end # class #{XSD::PREFIX_CLASS_CH}#{@internal_name}"
        puts

        puts "# Class to represent an option of the choice: #{@internal_name}"
        puts "#"
        puts to_str('# ')
        puts "class #{XSD::PREFIX_CLASS_CH_OPTION}#{@internal_name}"
      else
        # Choice that is single valued
        puts "class #{XSD::PREFIX_CLASS_CH}#{@internal_name}"
      end

      # Accessor for content

      puts "  # Names for the options in this choice."
      print "  NAMES = ["
      @element.each do |opt|
        identifier = opt.name ? opt.name : opt.ref
        print " :#{identifier},"
      end
      puts "]"
      puts

      # This method is not needed. There is probably no real need
      # for any program to clear a choice. If needed, add this
      # code to the END_OPTION_METHODS below.
      #
      #  # Clear any choice
      #  def _reset
      #    if @_index
      #      @_values[@_index] = nil
      #      @_index = nil
      #    end
      #  end

      puts <<"END_OPTION_METHODS"
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
      raise IndexError, \"choice has no option: \#{symbol}\"
    end
  end

  # Get value of the option indicated by +symbol+.
  # Returns +nil+ if the choice is not set to that option.
  # See the +NAMES+ constant for permitted values for +symbol+.
  def [](symbol)
    match = NAMES.index(symbol)
    match ? @_value : nil
  end

END_OPTION_METHODS

  count = 0
  @element.each do |opt|
    identifier = opt.name ? opt.name : opt.ref
    puts "  # Get the value of option +#{identifier}+. Returns +nil+ if not the option."
    puts "  def #{identifier}"
    puts "    #{count} == @_index ? @_value : nil"
    puts "  end"

    puts "  # Set the choice to be option +#{identifier}+ with the +value+."
    puts "  def #{identifier}=(value)"
    puts "    @_index = #{count}"
    puts "    @_value = value"
    puts "  end"
    puts
    count += 1
  end

  # XML output method for a choice

  # Determine which (if any) elements are primatives, since non-primitives
  # will have an 'xml' method, but primatives won't.

  primitives = []
  count = 0
  @element.each do |opt|
    if (opt.type == 'xsd:string' ||
        opt.type == 'xsd:anyURI')
      primitives << count
    end
    count += 1
  end

  puts "  # Serialize as XML"
  puts "  def xml(out, indent)"
  puts "    if @_index"

  if primitives.empty?
    # All options are not primitives
    need_primitive_support = false
    need_xml_method_support = true
  elsif primitives.length == @element.length
    # All options are primitives
    need_primitive_support = true
    need_xml_method_support = false
  else
    # A mixture of both primitives and non-primitives
    need_primitive_support = true
    need_xml_method_support = true
  end
  need_both = need_primitive_support && need_xml_method_support

  if need_both
    print "      if ["
    primitives.each { |p| print " #{p}," }
    puts "].include?(@_index)"
  end

  if need_primitive_support
    puts "        # Primitive"
    puts "        out.print indent"
    puts "        out.print \"<\#{NAMES[@_index]}>\""
    puts "        out.print @_value"
    puts "        out.print \"</\#{NAMES[@_index]}>\\n\""
  end

  if need_both
    puts "      else"
  end

  if need_xml_method_support
    puts "        # Non-primitive"
    puts "        @_value.xml(NAMES[@_index], out, indent)"
  end

  if need_both
    puts "      end"
  end

  puts "    end"
  puts "  end"
  puts

  if multiples?
    # Choice that is multivalued
    puts "end # class #{XSD::PREFIX_CLASS_CH_OPTION}#{@internal_name}"
  else
    # Choice that is single valued
    puts "end # class #{XSD::PREFIX_CLASS_CH}#{@internal_name}"
  end

  puts
end

def generate_parser(context)

  #      puts "  offset = 0"
  #      puts "  while offset < node.children.size"
  #      puts "    child = node.children[offset]"
  #
  #      puts "    case"
  #      puts "    when child.is_a?(REXML::Element)"
  #      puts "      value, offset = #{XSD::PREFIX_PARSE_CH_PARTICLE}#{@choice[0].internal_name} node, offset"
  #      puts
  #      puts "    when child.is_a?(REXML::Text)"
  #      puts "      expecting_whitespace child"
  #      puts "      offset += 1"
  #      puts "    when child.is_a?(REXML::Comment)"
  #      puts "      # Ignore comments"
  #      puts "      offset += 1"
  #      puts "    else"
  #      puts "      raise InvalidXMLError, \"Unknown node type: \#{child.class}\""
  #      puts "    end"
  #      puts "  end # while"

  # Generate for nested subcomponents

  @element.each { |x| x.generate_parser(context) }

  # Generate for self

  puts "# Parser for choice: <code>#{@internal_name}</code>"
  puts

  puts "def self.#{XSD::PREFIX_PARSE_CH}#{@internal_name}(nodes, offset)"

  puts "  # Create result object"

  module_name = context.current.module_name
  puts "  result = #{module_name}::#{XSD::PREFIX_CLASS_CH}#{@internal_name}.new"
  puts

  puts "  # Parse choice"

  puts "  while offset < nodes.length do"
  puts "    node = nodes[offset]"
  puts "    if node.is_a?(REXML::Element)"

  if multiples?
    # Choice that is multivalued
    puts "      opt = #{XSD::PREFIX_CLASS_CH_OPTION}#{@internal_name}.new" # new member
  end

  count = 0
  @element.each do |opt|  # FIXME: should loop over children not just elements
    if opt.is_a? XSD_element

      # Determine the parser method to call to parse this element

      if opt.type
        # Named datatype
        if opt.type == 'xsd:string'
          parse_method = "#{PREFIX_PARSE_PR}string"
        elsif opt.type == 'xsd:anyURI'
          parse_method = "#{PREFIX_PARSE_PR}string" # TODO: treating anyURI as string
        else
          ct = context.find_complexType(opt.type_local, opt.type_ns)
          if ! ct
            raise "unknown complexType: #{opt.type}"
          end
          parse_method = "#{XSD::PREFIX_PARSE_CT}#{ct.internal_name}"
        end
        element_name = opt.name

      elsif opt.ref
        # Reference to an element declaration
        el = context.find_element(opt.ref_local, opt.ref_ns)
        if ! el
          raise "unknown element reference: #{opt.ref}"
        end
        parse_method = "#{XSD::PREFIX_PARSE_EL}#{el.name}"
        element_name = el.name

      elsif 1 == opt.complexType.length
        # Anonymous complexType
        ctname = opt.complexType[0].internal_name
        parse_method = "#{XSD::PREFIX_PARSE_CT}#{ctname}"
        element_name = opt.name

      else
        raise "opt: #{opt.dump}"
      end

      if count == 0
        print "      if "
      else
        print "      elsif "
      end
      puts "node.name == '#{element_name}' && node.namespace == NAMESPACE"

      print "        "
      if multiples?
        # Choice that is multivalued
        print "opt"
      else
        print "result"
      end
      puts ".#{element_name} = #{parse_method}(node)"

    else
      raise "TODO"
    end
    count += 1
  end
  puts "      else"
  puts "        raise InvalidXMLError, \"Unexpected element in choice: {\#{node.namespace}}\#{node.name}\""
  puts "      end"
  puts "      offset += 1"

  if multiples?
    # Choice that is multivalued
    puts "      result << opt"
  end

  puts "    elsif node.is_a?(REXML::Text)"
  puts "      expecting_whitespace node"
  puts "      offset += 1"
  puts "    elsif node.is_a?(REXML::Comment)"
  puts "      # Ignore comments"
  puts "      offset += 1"
  puts "    else"
  puts "      raise InvalidXMLError, \"Unknown node type: \#{child.class}\""
  puts "    end"
  puts "  end # while"

  if 0 < @minOccurs
    # Check minCccurs is satisified

    puts "  # Check minOccurs==#{@minOccurs}"
    if multiples?
      # Choice that is multivalued
      puts "  if result.length < #{@minOccurs}"
    else
      # Choice is single valued
      puts "  if ! result._option"
    end
    puts "    raise InvalidXMLError, \"Choice minOccurs not satisfied\""
    puts "  end"
  else
    puts "  # Check minOccurs: not necessary, since minOccurs==0"
  end

  if multiples?
    # Choice that is multivalued
    if ! unbounded?
      # maxOccurs is finite
      puts "  # Check maxOccurs==#{@maxOccurs}"
      puts "  if #{@maxOccurs} < result.length"
      puts "    raise InvalidXMLError, \"Choice maxOccurs exceeded\""
      puts "  end"
    end
  else
    # Choice that is single valued
    raise "TODO: handling maxOccurs = 0" if @maxOccurs != 1
  end

  puts "  # Return"
  puts "  return result, offset"

  puts "end"
  puts

end # def generate_parser

end

#----------------------------------------------------------------
# XML Schema element.

# XML Schema element.
#
# This class represents the declaration of an XML element. An XML element
# can be declared in one of three ways:
#
# * Defined by a datatype. Currently, only
#   complexTypes are supported, even though XML Schema allows other
#   named datatypes. The +name+ and +type+ must be set.
# * Anonymous complexType.
# * Reference to another element declaration. The +ref+ is set to the
#   name of that element declaration. Currently, this has not been implemented.

class XSD_element < XSD_particle

  # The name of the complexType (+nil+ if using +ref+)
  attr_accessor :name
  # The namespace of the +name+ (set by fix_names)
  attr_accessor :name_ns

  # Name of datatype for the element (+nil+ if using +ref+ or +complexType+)
  attr_accessor :type
  # The local name of the +type+ (set by fix_names)
  attr_accessor :type_local
  # The namespace of the +type+ (set by fix_names)
  attr_accessor :type_ns

  # Name of referenced element definition (+nil+ if using +type+ or
  # +complexType+)
  attr_accessor :ref
  # The local name of the +ref+ (set by fix_names)
  attr_accessor :ref_local
  # The namespace of the +ref+ (set by fix_names)
  attr_accessor :ref_ns

  # An array containing zero or one XSD_complexType object. If there
  # is one object, it defines the structure of this element and
  # +type+ and +ref+ needs to be +nil+.
  attr_accessor :complexType

  # Internal name used in name of classes, members and methods
  attr_accessor :internal_name

  # Create a new element declaration.

  def initialize
    super()
    @name = nil
    @type = nil
    @ref = nil
    @complexType = []
  end

  def get_actual_name(context)

    if @type != nil
      # Element defined by a named datatype
      return @name

    elsif ! @complexType.empty?
      # Element defined by an anonymous complexType
      return @name

    elsif @ref != nil
      # Element references another element
      target = context.lookup_element(@ref)
      return target.get_actual_name(context)

    else
      raise # TODO: unexpected form of element
    end

  end

  # Returns true if the element's value is a simple type. Being a
  # simple type means that it will be represented by a Ruby String
  # rather than a generated class. This method will follow references
  # if the element is define by a ref.
  def is_simple?(context)

    if @type != nil
      # Element defined by a named datatype

      if (@type == 'xsd:string' || # TODO: make it work with any prefix
          @type == 'xsd:anyURI')
        return true
      else
        return false
      end

    elsif ! @complexType.empty?
      # Element defined by an anonymous complexType
      return false

    elsif @ref != nil
      # Element references another element
      target = context.find_element(@ref_local, @ref_ns)
      return target.is_simple?(context)

    else
      raise # TODO: unexpected form of element
    end

  end

  def dump
    str = '{'
    str << " ref=#{@ref}" if @ref
    str << " type=#{@type}" if @type
    @complexType.each do |ct|
      str << " complexType=#{ct}/#{ct.internal_name}"
    end
    str << " internal_name=#{@internal_name}" if @internal_name
    str << ' }'
    str
  end

  def ncname_to_element_method_name(ncname)
      # Convert an element's name into a suitable method name.

      # The name of an attribute is xs:NCName, which is a non-colonized name.
      # From <http://www.w3.org/TR/1999/REC-xml-names-19990114/>:
      #   NCName ::= (Letter | '_') (NCNameChar)*
      #   NCNameChar ::= Letter | Digit | '.' | '-' | '_' | CombiningChar | Extender
      #
      # Ruby methods names, by convention should start with a capital letter, but
      # for consistency with name of the attribute, this convention will not be
      # followed.

      method_name = ncname.gsub(/\-\./, '_') # convert hyphens and full stops to underscore

      if ! Object.method_defined? method_name
        # No clash. Use the attribute local name as the accessor name
        method_name
      else
        # The name of this attribute will clash with an existing
        # method on the Object class. So use a different name for the
        # attribute.
        "#{method_name}#{SUFFIX_MEMBER_EL}"
      end
  end

  #----------------
  # Prepares an XSD element for procesing.
  def fix_names(context)
    fix_occurs
    @complexType.each { |x| x.fix_names(context) }

    # Process the four kinds of element declaration:
    # type and name; ref, complexType and name; empty and name

    if @type != nil
      raise 'internal error' if ! @name
      @type_ns, @type_local = XSD.lookup_QName(context, @type)
      @internal_name = ncname_to_element_method_name(@name)

    elsif @ref != nil
      raise 'internal error' if @name
      # TODO
      @ref_ns, @ref_local = XSD.lookup_QName(context, @ref)
      @internal_name = "ref_to_#{@ref}" # TODO: lookup ref's real name

    elsif 1 == @complexType.length
      raise 'internal error' if ! @name
      @internal_name = ncname_to_element_method_name(@name)

    elsif 0 == @complexType.length
      raise 'internal error' if ! @name

    else
      raise
    end

    if @name
      # Name is an ncname, so the namespace is always the current one
      @name_ns = context.current.namespace
    end

    # Check

    if @ref && @complexType.length != 0 ||
       @type && @complexType.length != 0 ||
       @ref && @type
      raise "internal error: element with multiple ref, type or complexType"
    end
  end

  #----------------
  # Generate code to define classes to represent instances of this element.
  def generate_classes(context)
    @complexType.each { |x| x.generate_classes(context) }
  end

  #----------------
  # Generate code to parse this element.
  def generate_parser(context)

    # Parser for nested subcomponents

    @complexType.each { |x| x.generate_parser(context) }

  end

  #----------------
  # Generate code to parse this element as a top level element.
  # This is only used for elements declared at the top level of the
  # XML Schema, because they are the only ones that can be parsed for
  # outside the context of another element.
  def generate_entry_point(context)

    puts "# Parser for top level element +#{@name}+"

    puts "def self.#{XSD::PREFIX_PARSE_EL}#{@name}(src)"
    puts "  root = src_to_dom src"
    puts

    puts "  expecting_element '#{@name}', root"

    if @type != nil
      # Defined by a named datatype
      puts "  #{XSD::PREFIX_PARSE_CT}_DATATYPE_#{@type}(root) # type"

    elsif @ref != nil
      # Define by a reference to another element
      target = context.get_element(@ref)
      if ! target
        raise "element reference unknown: #{@ref}"
      end
      puts "  #{XSD::PREFIX_PARSE_CT}_REF_TO_#{target.name}(root) # ref"

    elsif 1 == @complexType.length
      # Defined by an anonymous complexType
      puts "  #{XSD::PREFIX_PARSE_CT}#{@complexType[0].internal_name}(root)"

    elsif 0 == @complexType.length
      # Element with no content model and no attributes
      puts "  parse_empty(root)"

    else
      raise "internal error"
    end

    puts "end"
    puts
  end

end

#----------------------------------------------------------------

# Represents an <code>xsd:complexType</code>.
#
# Currently, only three types of complexTypes content models are supported:
#
# * Sequence, where +sequence+ contains exactly one XSD::XSD_sequence
#   object and the +choice+ and +simpleContent+ are both empty arrays.
#
# * Choice, where +choice+ contains exactly one XSD::XSD_choice object
#   and the +sequence+ and +simpleContent+ are both empty arrays.
#
# * Simple content, where +simpleContent+ contains exactly one
#   XSD::XSD_simpleContent object and +sequence+ and +choice+ are both
#   empty arrays.

class XSD_complexType < Base

  # Name of the complexType (+nil+ for anonymous complexTypes)
  attr_accessor :name

  # Content model: array of zero or one XSD::XSD_simpleContent objects
  attr_accessor :simpleContent

  # Content model: array of zero or one XSD::XSD_sequence objects
  attr_accessor :sequence

  # Content model: array of zero or one XSD::XSD_choice objects
  attr_accessor :choice

  # Array of zero or more XSD::XSD_attribute objects
  attr_accessor :attribute

  # Array of zero or more XSD::XSD_attributeGroup objects
  attr_accessor :attributeGroup

  attr_accessor :internal_name

  def initialize
    super()
    @simpleContent = []
    @sequence = []
    @choice = []
    @attribute = []
    @attributeGroup = []
  end

  def fix_names(context)
    set = 0
    set += 1 if ! @simpleContent.empty?
    set += 1 if ! @sequence.empty?
    set += 1 if ! @choice.empty?
    if 1 < set
      raise "complexType has more than one simpleContent/sequence/choice"
    end

    if instance_variable_defined?(:@name)
      @internal_name = @name
    else
      @internal_name = context.nextname()
    end

    if ! @simpleContent.empty?
      @simpleContent.each { |x| x.fix_names(context) }
    elsif ! @sequence.empty?
      @sequence.each { |x| x.fix_names(context) }
    elsif ! @choice.empty?
      @choice.each { |x| x.fix_names(context) }
    end

    @attribute.each { |x| x.fix_names(context) }
    @attributeGroup.each { |x| x.fix_names(context) }

    raise if 1 < @simpleContent.length
    raise if 1 < @sequence.length
    raise if 1 < @choice.length
  end

  def generate_classes(context)

    # Generate for nested subcomponents

    @sequence.each { |x| x.generate_classes(context) }
    @choice.each { |x| x.generate_classes(context) }

    # Generate for self

    puts "# Class to represent the complexType: #{@internal_name}"
    puts "#"
    puts to_str('# ')
    puts "class #{XSD::PREFIX_CLASS_CT}#{@internal_name} < Base"

    # Accessors for attributes (if any)

    @attribute.each do |attr|
      attr.gen_accessor(context)
    end
    @attributeGroup.each do |ag|
      ag.gen_accessors(context)
    end

    # Accessors for content model

    if ! @simpleContent.empty?
      # ComplexType with simpleContent
      @simpleContent[0].gen_accessors(context)

    elsif ! @sequence.empty?
      # ComplexType with sequence

      puts "  # For internal use"
      puts "  attr_writer :_sequence # the sequence object"

      @sequence[0].members.each do |member|
        # Redirect accessors to the members of the sequence
        n = member.internal_name
        puts "  # Child element getter"
        puts "  def #{n}; @_sequence.#{n} end"
        puts "  # Child element setter"
        puts "  def #{n}=(value); @_sequence.#{n}(value) end"
      end

    elsif ! @choice.empty?
      # ComplexType with choice

      if @choice[0].multiples?
        # A repeatable choice
        puts "  attr_accessor :_choices # the choices (an array)"
        # Cannot redirect accessor to the options
      else
        # A singular choice
        puts "  attr_writer :_choice # the choice"

        # Redirect accessors to the options of the choice for convenience
        @choice[0].element.each do |opt|
          n = opt.internal_name
          puts "  # The choice's get option"
          puts "  def #{n}; @_choice.#{n} end"
          puts "  # The choice's set option"
          puts "  def #{n}=(value); @_choice.#{n}(value) end"
        end
      end

    else
      # empty content model
    end

    # XML output method for the complexType

    module_name = context.current.module_name

    if ! @simpleContent.empty?
      @simpleContent[0].gen_xml(module_name)

    else
      puts "  # Serialize as XML."
      puts "  # The +ename+ (+String+) is used as the element name and the"
      puts "  # XML is written to +out+ (+IO+) with indenting of +indent+."
      puts "  def xml(ename, out, indent='')"

      puts "    out.print \"\#{indent}<\#{ename}\" # start tag"
      @attribute.each do |attr|
        attr.gen_xml(module_name)
      end
      puts "    out.print \">\""

      if ! @sequence.empty?
        puts "    out.puts"
        puts "    @_sequence.xml(out, indent)"
        puts "    out.print indent"
      elsif ! @choice.empty?
        puts "    out.puts"
        puts "    @_choices.xml(out, indent+'  ')"
        puts "    out.print indent"
      else
        # empty content model
      end

      puts "    out.print \"</\#{ename}>\\n\" # end tag"
      puts "  end"
      puts
    end

    # End class definition for complexType

    puts "end # class #{XSD::PREFIX_CLASS_CT}#{@internal_name}"
    puts

  end

  def generate_parser(context)
    # Generate for nested subcomponents

    @sequence.each { |x| x.generate_parser(context) }
    @choice.each { |x| x.generate_parser(context) }

    # Generate for self

    module_name = context.current.module_name

    puts "# Parser for complexType: <code>#{@internal_name}</code>"
    puts

    puts "def self.#{XSD::PREFIX_PARSE_CT}#{@internal_name}(node)"
    puts

    puts "  # Create result object"
    puts "  result = #{module_name}::#{XSD::PREFIX_CLASS_CT}#{@internal_name}.new"
    puts "  result.xml_src_node = node"
    puts

    # Parse attributes

    if 0 < @attribute.length
      puts "  # Parse attributes"
      @attribute.each do |attr|
        attr.gen_parser(context, 'node', 'result')
      end
    end
    if 0 < @attributeGroup.length
      puts "  # Parse attributeGroups"
      @attributeGroup.each do |attr_group|
        attr_group.gen_parser(context)
      end
    end

    # Parse content model

    puts "  # Content model"

    if ! @simpleContent.empty?
      # simpleContent

      @simpleContent[0].gen_parser(context, 'node', 'result')

    elsif ! @sequence.empty?
      # sequence

      puts "  result._sequence, offset = #{XSD::PREFIX_PARSE_SE}#{@sequence[0].internal_name}(node.children, 0)"
      puts "  if offset < node.children.size"
      puts "     raise \"complexType sequence has left over elements\""
      puts "  end"

    elsif ! @choice.empty?
      # choice

      if @choice[0].multiples?
        print "  result._choices"
      else
        print "  result._choice"
      end
      puts ", offset = #{XSD::PREFIX_PARSE_CH}#{@choice[0].internal_name}(node.children, 0)"

      puts "  if offset < node.children.size"
      puts "     raise \"complexType choice has left over elements\""
      puts "  end"

    else
      # empty content model
    end

    puts
    puts "  # Success"
    puts "  result"
    puts "end"
    puts

  end # def generate_parser

end

#----------------------------------------------------------------

# XML Schema
class XSD_schema < Base
  attr_accessor :version
  attr_accessor :elementFormDefault
  attr_accessor :attributeFormDefault
  attr_accessor :targetNamespace
  attr_accessor :xmlns
  attr_accessor :xsd
  attr_accessor :import
  attr_accessor :include
  attr_accessor :attribute
  attr_accessor :attributeGroup
  attr_accessor :complexType
  attr_accessor :element

  def initialize
    super()
    @import = []
    @include = []
    @attribute = []
    @attributeGroup = []
    @complexType = []
    @element = []
  end

  def fix_names(context)
    @complexType.each { |x| x.fix_names(context) }
    @element.each { |x| x.fix_names(context) }
    @attributeGroup.each { |x| x.fix_names(context) }
  end

  def generate_classes(context)
    @complexType.each { |x| x.generate_classes(context) }
    @element.each { |x| x.generate_classes(context) }
  end

  def generate_parser(context)
    @attributeGroup.each { |x| x.generate_parser(context) }
    @complexType.each { |x| x.generate_parser(context) }
    @element.each { |x| x.generate_parser(context) }

    @element.each { |x| x.generate_entry_point(context) }
  end

end

end # module

#================================================================

# Represents the XML Schema environment for generating code.
#
# It identifies all the named XSD::XSD_element and XSD::XSD_complexType
# objects from all the known XML Schemas. This allows the code generator
# to easily process elements defined by a +ref+ to an element
# declaration or by +type+ to a named datatype.
#
# Limitation: other named components (e.g. groups) should be added to this
# when they are supported.



#================================================================

class Codegen_context

  class NamespaceInfo
    attr_accessor :namespace
    attr_accessor :module_name

    def initialize(ns)
      super()
      @namespace = ns
      @schemas = []

      @sources = {}

      @named_attributeGroups = {}
      @named_elements = {}
      @named_complexTypes = {}
    end

    def add_schema(schema, source)

      if @sources[source]
        # A schema already exists from that source, so don't
        # add it again. Do nothing.
        return
      end

      # Append the schema to the list of schemas

      @schemas << schema
      @sources[source] = true

      # Update table of named components for quicker lookup

# TODO: support named attributes
#      schema.attributes.each do |a|
#        if @attributes[a.name]
#          raise "duplicate top level attribute: #{a.name}"
#        end
#        @attributes[a.name] = a
#      end
#
# TODO: support simpleTypes

      schema.attributeGroup.each do |ag|
        if @named_attributeGroups[ag.name]
          raise "duplicate attributeGroup: #{ag.name}"
        end
        @named_attributeGroups[ag.name] = ag
      end

      schema.element.each do |e|
        if @named_elements[e.name]
          raise "duplicate top level element: #{e.name}"
        end
        @named_elements[e.name] = e
      end

      schema.complexType.each do |ct|
        if @named_complexTypes[ct.name]
          raise "duplicate top level complexType: #{ct.name}"
        end
        @named_complexTypes[ct.name] = ct
      end

    end

    def get_schemas
      @schemas
    end

    def find_attributeGroup(name)
      @named_attributeGroups[name]
    end

    def find_element(name)
      @named_elements[name]
    end

    def find_complexType(name)
      @named_complexTypes[name]
    end

  end # class NamespaceInfo

  #----------------

  attr_reader :namespaces
  attr_reader :current

  def initialize
    super()
    # Ordered list of known namespaces
    @namespaces = []
    # Main data structure to hold the information. This is a hash
    # where the key is the namespace and the value is a NamespaceInfo
    # object.
    @data = {}

    # Members used for name generation
    @base = '_anon'
    @count = 0
  end

  def add_schema(schema, source)
    ns = schema.targetNamespace

    info = @data[ns]
    if info
      # Namespace already known
      info.add_schema(schema, source)
    else
      # Namespace not yet known
      @namespaces << ns
      info = NamespaceInfo.new(ns)
      info.add_schema(schema, source)
      @data[ns] = info
    end
  end

  def get_schemas(namespace)
    info = @data[namespace]
    info ? info.get_schemas : nil
  end

  # Set the module name for the given +namespace+. The module name will
  # be used in code generation.
  def set_module_name(namespace, mod_name)

    info = @data[namespace]
    if ! info
      raise "unknown namespace: #{namespace}"
    end

    if mod_name !~ /^[A-Z]/
      raise "module name must begin with an uppercase letter: #{mod_name}"
    end

    info.module_name = mod_name
  end

  def get_module_name(namespace)
    info = @data[namespace]
    info ? info.module_name : nil
  end

  def find_attributeGroup(name, namespace)
    info = @data[namespace]
    info ? info.find_attributeGroup(name) : nil
  end

  def find_element(name, namespace)
    info = @data[namespace]
    info ? info.find_element(name) : nil
  end

  def find_complexType(name, namespace)
    info = @data[namespace]
    info ? info.find_complexType(name) : nil
  end


  def set_current(namespace)
    if namespace
      info = @data[namespace]
      if ! info
        raise "unknown namespace: #{namespace}"
      end
      @current = info
    else
      @current = nil # clear the current namespace
    end
  end

  # Methods for name generation

  def nextname
    @count += 1
    "#{@base}#{@count}"
  end

end # class Codegen_context

#================================================================

def output_ruby_header(namespace, module_name)

  puts <<"END_HEADER"
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
#   obj, name = #{module_name}.parser(src)
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

require 'REXML/document'

module #{module_name}

# Target XML namespace for this module.
NAMESPACE='#{namespace}'

  class Base
    # The REXML::node from which this object was parsed,
    # or +nil+ if this object was not parsed from XML.
    attr_writer :xml_src_node

    def expand_qname(qname)
      a, b = qname.split(':')
      if b
        # a=prefix; b=localname
        [ "http://debug.namespace/prefix/\#{a}", b ] # TODO
      else
        # a=localname (in current namespace)
        [ 'http://debug.namespace/default-namespace', a ] # TODO
      end
    end

  end # class Base

END_HEADER
end # output_ruby_header

def output_parser_common_code(module_name)

  puts <<"END_PARSER_COMMON"

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
     s.gsub!('\\\'', '&apos;')
     s.gsub!('\"', '&quot;')
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
        e = ArgumentError.new "\#{__method__} expects a File, String or REXML::Element"
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
        raise InvalidXMLError, "mandatory attribute missing: \#{name}"
      end
      a.value
    end

    # Parses the +node+ for character data content. Assumes the +node+
    # is an REXML::Element object. Returns a +String+ or raises
    # an exception if the element does not just contain character data.
    def self.#{XSD::PREFIX_PARSE_PR}string(node)
      # Parse element containing just text

      value = ''
      node.each_child do |child|
        case
        when child.is_a?(REXML::Element)
          raise InvalidXMLError, "Unexpected element:" \
          " {\#{child.namespace}}\#{child.name}"

        when child.is_a?(REXML::Text)
          value << REXML::Text.unnormalize(child.to_s)

        when child.is_a?(REXML::Comment)
          # Ignore comments

        else
          raise InvalidXMLError, "Unknown node type: \#{child.class}"
        end
      end
      value
    end # def parse_text

    # Parses an empty element. Such elements contain no attributes
    # and no content model.
    def self.parse_empty(node)
      # TODO: check for no attributes

      node.each_child do |child|
        case
        when child.is_a?(REXML::Element)
          raise InvalidXMLError, "unexpected element in empty content model: {\#{child.namespace}}\#{child.name}"
        when child.is_a?(REXML::Text)
          expecting_whitespace child
        when child.is_a?(REXML::Comment)
          # Ignore comments
        else
          raise InvalidXMLError, "unknown node type: \#{child.class}"
        end
      end

    end

    # Checks if the +node+ represents an element with the given
    # +element_name+. Assumes that the +node+ is an
    # +REXML::element+ object. Raises an exception if it is not.
    def self.expecting_element(element_name, node)

      if node.name != element_name || node.namespace != #{module_name}::NAMESPACE
        raise InvalidXMLError, "Unexpected element:" \
        " expecting {\#{#{module_name}::NAMESPACE}}\#{element_name}:" \
        " got {\#{node.namespace}}\#{node.name}"
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

#================================================================
# Parse explicitly identified element methods

END_PARSER_COMMON
end # output_parser_common_code

def output_top_parser_method(top_level_elements)
  puts <<"END_PARSER_MAIN"
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
END_PARSER_MAIN

  top_level_elements.each do |e|
    puts "# * <code>#{e.name}</code>"
  end

  puts <<"END_PARSER_MAIN"
#
# === Exceptions
# InvalidXMLError
def self.parse(src)
  root = src_to_dom(src)

  # Try to parse any of the known top level elements
END_PARSER_MAIN

  first = true
  top_level_elements.each do |e|
    print first ? '  if' : '  elsif'
    puts " root.name == '#{e.name}'"
    puts "    return [ #{XSD::PREFIX_PARSE_EL}#{e.name}(root), '#{e.name}' ]"
    first = false
  end

  puts "  else"
  puts "    raise \"could not parse any known element\""
  puts "  end"
  puts "end" # def self.parse
  puts
end

#----------------------------------------------------------------

def output_classes(context, schemas)
  schemas.each do |s|
    s.generate_classes(context)
  end
end

#----------------------------------------------------------------

def output_parser_code(context, schemas)

  # Start the module for this namespace

  # Output general parsing methods

  schemas.each do |s|
    s.generate_parser(context) # Parser entry point methods
  end

  # Collect all the top level elements for the schemas in this namespace

  top_level_elements = []
  schemas.each do |s|
    s.element.each do |e|
      top_level_elements << e
    end
  end

  if ! top_level_elements.empty?
    # There are top level elements declared, so output a parse method
    output_top_parser_method(top_level_elements)
  end

end

#----------------------------------------------------------------

def output_ruby_footer(module_name)

  puts <<"END_FOOTER"
end # module #{module_name}

#EOF
END_FOOTER

end

#----------------------------------------------------------------

def generate_ruby(context, outdir)

  # Normalise all schema

  context.namespaces.each do |namespace|
    context.set_current(namespace)

    context.get_schemas(namespace).each do |s|
      s.fix_names(context)
    end
  end

  # Output the code for every namespace

  context.namespaces.each do |namespace|

    # Open output file

    if outdir != '-'
      # User did not request output to stdout
      begin
        filename = outdir
        filename += '/' if ! filename.end_with?('/')
        filename += context.get_module_name(namespace)
        filename += '.rb'
        $stdout = File.open(filename, 'w');
      rescue => e
        $stderr.puts "Error: output file: #{e.message}"
        exit 1
      end
    end

    # Generate code

    module_name = context.get_module_name(namespace)
    schemas = context.get_schemas(namespace)

    context.set_current(namespace)

    output_ruby_header(namespace, module_name)
    output_classes(context, schemas)
    output_parser_common_code(module_name)
    output_parser_code(context, schemas)
    output_ruby_footer(module_name)

    # Close output file

    if outdir != '-'
      $stdout.close
    end
  end

end # def generate_ruby

#----------------------------------------------------------------

def process_command_line

  # Specify command line options

  options = {}
  opt_parser = OptionParser.new do |opt|
    opt.banner = "Usage: PROG [options] XMLSchemaFiles"

    opt.separator "Options:"

    opt.on("-o", "--outdir dir", "output directory") do |param|
      options[:outdir] = param
    end

    opt.on("-m", "--module names", "names of module (comma separated)") do |param|
      options[:modules] = param
    end

    opt.on("-P", "--preparsed code", "preparsed") do |param|
      options[:preparsed] = param
    end

    opt.on("-v", "--verbose", "verbose output") do
      options[:verbose] = true
    end

    opt.on("-h", "--help", "show help message") do
      $stderr.puts opt_parser
      exit 0
    end
  end
  opt_parser.version = 1.0
  opt_parser.release = 1024

  # Parse parameters

  begin
    opt_parser.parse!
  rescue OptionParser::InvalidOption => e
    $stderr.puts "Usage error: #{e.message} (--help for help)"
    exit 2
  rescue OptionParser::InvalidArgument => e
    $stderr.puts "Usage error: #{e.message}"
    exit 2
  end

  # Use parameters

  if ! options[:modules]
    $stderr.puts "Usage error: module names missing (use --module)"
    exit 2
  end

  if ! options[:outdir]
    options[:outdir] = '.' # default to current directory
  end

  if ARGV.empty?
    # In the interim implementation that uses the preparsed code
    # instead of XML Schema files, this check is not required
    #$stderr.puts "Usage error: missing input schema filenames (-h for help)"
    #exit 2
  end

  return [ ARGV,
           options[:verbose], options[:modules],
           options[:outdir], options[:preparsed] ]

end # def process_command_line

#----------------------------------------------------------------

def main

  filenames,
  verbose, module_names,
  outdir, preparsed = process_command_line

  # Load XML Schemas

  # Currently this uses the interim parsing code output from
  # 'xml-to-code.rb'. It does not validation of the schema
  # and it represents all content model items as arrays
  # instead of (more nicely) representing them an object
  # if they are not repeating.

  context = Codegen_context.new

  if preparsed
    if ! filenames.empty?
      $stderr.puts "Warning: ignoring files, using preparsed: #{preparsed}"
    end

    require preparsed
    schemas = parse_XSD

    count = 0
    schemas.each do |schema|
      count += 1
      context.add_schema(schema, "preparsed-file-#{count}")
    end
  else
    raise "Internal error: schema parsing not implemented (use --preparsed)"
  end

  # Set the module names from the command line parameter

  list_mod = module_names.split(',')
  list_ns = context.namespaces

  if list_mod.length != list_ns.length
    $stderr.puts "Usage error: number of module names" \
    " does not match the number of unique schema namespaces:" \
    " #{list_mod.length} != #{list_ns.length}"
    exit 2
  end

  list_ns.each_index do |i|
    module_name = list_mod[i]
    module_name.sub!(/^\s+/, '')
    module_name.sub!(/\s+$/, '')
    if module_name.empty?
      $stderr.puts "Usage error: module name cannot be an empty string"
      exit 2
    end
    if module_name !~ /^[A-Z_][0-9A-Za-z_]*$/
      $stderr.puts "Usage error: not a suitable module name: #{module_name}"
      exit 2
    end

    context.set_module_name(list_ns[i], module_name)
  end

  # Generate code

  generate_ruby(context, outdir)

  0 # success
end

exit main

#EOF
