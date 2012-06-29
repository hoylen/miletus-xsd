#!/usr/bin/ruby -w
#

require 'xsd-info'

#================================================================

# Extends the XSDInfo with methods for generating Ruby code.

class XSDInfoRuby < XSDInfo

  attr_accessor :module_name

  COMMENT_SEPARATOR = '#' + '-' * 64
  COMMENT_SEPARATOR_CLASSES = '#' + '-' * 16

  PREFIX_PARSE = 'parse_'

  def initialize(namespace)
    super(namespace)

    # These are used for name generation

    @choice_name_bases_used = {} # keep track of generated choice base names
    @choice_name_count = 0 # used to generate unique names for choice base names
    @sequence_name_bases_used = {} # keep track of generated sequence base names
    @sequence_name_count = 0 # used to generate unique names for sequence base names
    @complexType_name_bases_used = {} # keep track of generated complexType base names
    @complexType_name_count = 0 # used to generate unique names for complexType base names
  end

  #----------------------------------------------------------------

  CLASS_PREFIX = {
    :attributeGroup => 'AttributeGroup_',
    :complexType => 'ComplexType_',
    :sequence => 'Sequence_',
    :choice => 'Choice_',
    :choice_list => 'Choices_',
  }

  def ncname_to_classname(type, ncname)
    raise "internal error: not an NCName: #{ncname}" if ncname =~ /\:/

    prefix = CLASS_PREFIX[type]
    if ! prefix
      raise "internal error: no prefix in CLASS_PREFIX for #{type}"
    end

    str = ncname
    str.gsub!('-', '_')
    str.gsub!('.', '_')

    CLASS_PREFIX[type] + str
  end

  MEMBER_SUFFIX = {
    :attribute => '_attribute',
    :element => '_element',
    :sequence => '_sequence',
    :choice => '_choice'
  }

  def ncname_to_membername(type, ncname)
    raise "internal error: not an NCName: #{ncname}" if ncname =~ /\:/

    suffix = MEMBER_SUFFIX[type]
    if ! suffix
      raise "internal error: no suffix in MEMBER_SUFFIX for #{type}"
    end

    # Use provided ncname, but with unsuitable characters changed

    str = ncname
    str.gsub!('-', '_')
    str.gsub!('.', '_')

    if Object.method_defined? str
      # Name clash with an existing method on the Object class.
      # For example, an attribute or element called 'type' will
      # trigger this. Generate a unique name using the suffix.
      str += suffix
    end

    str
  end

  #----------------------------------------------------------------

  # Gets the namespace name and local part of a QName (XML qualified
  # name) from a lexical representation of that QName. The lexical
  # representation consists an optional prefix followed by a colon,
  # followed by the local part. The prefix is mapped into the
  # namespace name according to the namespace declarations of the
  # current XML node. If there is no prefix, then the default namespace
  # is the namespace name of the QName.
  #
  # For example, if context represents the following element,
  # this method can be used to expand the two attribute values.
  #
  #   <myelement xmlns="http://ns.example.com/def/1.0"
  #              xmlns:foo="http://ns.example.com/foo/1.0"
  #              myqname1="foo:bar"
  #              myqname2="baz"/>
  #
  #   expand_qname("foo:bar" => [ "http://ns.example.com/foo/1.0", "bar" ]
  #   expand_qname("baz" => [ "http://ns.example.com/def/1.0", "baz" ]

  def expand_qname(context, qname)
    a, b = qname.split(':')
    if b
      # a=prefix; b=localname
      ns = context.xml_src_node.namespace(a)
      localname = b
    else
      # unprefixed; a=localname
      ns = context.xml_src_node.namespace('')
      localname = a
    end
    if ! ns
      if b && a == 'xml'
        ns = 'http://www.w3.org/XML/1998/namespace'
      else
        raise "unknown namespace for QName \"#{qname}\""
      end
    end
    [ ns, localname ]
  end

  #================================================================
  #---
  # Classification methods. These are used in the preprocessing
  # operation to set the _form for attributes, complexTypes and
  # elements. The _form is subsequently used to determine how
  # these objects should be processed, without having to re-determine
  # the form again.

  # Sets the _form of the attribute +attr+.

  def classify_attribute(attr)
    # Classify the attribute declaration

    match = 0
    if attr.type_attribute
      attr._form = :attribute_type
      match += 1
    end
    if attr.ref
      attr._form = :attribute_ref
      match += 1
    end

    if attr.simpleType
      attr._form = :attribute_anonymous_simpleType
      match += 1
    end

    if match != 1
      raise 'internal error' # expecting exactly one of the above forms
    end
  end

  # Sets the _form of the attributeGroup +ag+.

  def classify_attributeGroup(ag)
    # Classify the attribute group

    match = 0

    if ag.name
      ag._form = :attributeGroup_def
      match += 1
    end

    if ag.ref
      ag._form = :attributeGroup_ref
      match += 1
    end

    if match != 1
      raise 'internal error' # expecting exactly one of the above forms
    end
  end

  # Sets the _form of the complexType +ct+.

  def classify_complexType(ct)

    match = 0
    content_model = ct.choice1

    if content_model
      option = content_model._option

      if option == :simpleContent
        ct._form = :complexType_simpleContent
        match += 1
      end
      if option == :sequence
        ct._form = :complexType_sequence
        match += 1
      end
      if option == :choice
        ct._form = :complexType_choice
        match += 1
      end
    else
      ct._form = :complexType_empty
      match += 1
    end

    if match != 1
      raise 'internal error' # expecting exactly one of the above forms
    end
  end

  # Sets the _form of the element +element+.

  def classify_element(element)
    # Classify the element declaration

    match = 0

    if element.type_attribute
      element._form = :element_type
      match += 1
    end

    if element.ref
      element._form = :element_ref
      match += 1
    end

    if element.choice
      if element.choice.complexType
        element._form = :element_anonymous_complexType
        match += 1
      else
        raise 'internal error' # currently no other anonymous definitions supported
      end
    end

    if match == 0
      element._form = :element_empty
    elsif match == 1
      # one of the above matched
    else
      raise 'internal error' # expecting not more than one of the above forms
    end
  end

  #================================================================
  # Preprocessing methods

  public

  # Preprocess the schema so it is ready for code generation.

  def preprocess

    # Note: the sorting is not required. It is just there to make it
    # more deterministic for debugging. Sorting can be removed
    # to improve performance in production.

    @named_attributes.sort.each do |name, item|
      preprocess_attribute(item)
    end

    @named_attributeGroups.sort.each do |name, item|
      preprocess_attributeGroup(item)
    end

    @named_complexTypes.sort.each do |name, item|
      preprocess_complexType(item)
    end

    @named_elements.sort.each do |name, item|
      preprocess_element(item)
    end

  end

  private

  def preprocess_attribute(attr)

    classify_attribute(attr)

    # Other preprocessing

    need_name = false

    case attr._form
    when :attribute_type
      ns, localname = expand_qname(attr, attr.type_attribute)
      target = collection.find_type(ns, localname)
      if ! target
        raise "type cannot be resolved: #{attr.type_attribute}"
      end
      attr._type_target = target
      # TODO: only allow simple types to be attribute types
      need_name = true

    when :attribute_anonymous_simpleType
      preprocess_simpleType(attr.simpleType)
      need_name = true

    when :attribute_ref
      ns, localname = expand_qname(attr, attr.ref)
      target = collection.find_attribute(ns, localname)
      if ! target
        raise "attribute ref cannot be resolved: #{attr.ref}"
      end
      attr._ref_target = target

    else
      raise 'internal error'
    end

    if need_name
      # Preprocess the name
      attr._member_name = ncname_to_membername(:attribute, attr.name)
      attr._module_name = @module_name
    else
      attr._member_name = ncname_to_membername(:attribute, 'ref_to_attribute')
    end
  end

  def preprocess_attributeGroup(attr_group)

    classify_attributeGroup(attr_group)

    case attr_group._form
    when :attributeGroup_def
      # attributeGroup definition

      attr_group._module_name = @module_name
      attr_group._class_name = ncname_to_classname(:attributeGroup, attr_group.name)

      attr_group.choice.each do |item|
        case item._option
        when :attribute
          preprocess_attribute(item.attribute)
        when :attributeGroup
          preprocess_attributeGroup(item.attributeGroup)
        else
          raise 'internal error: invalid attributeGroup'
        end
      end

    when :attributeGroup_ref
      # attributeGroup reference (i.e. being used)
      target = collection.find_attributeGroup(namespace, attr_group.ref)
      if ! target
        raise "attributeGroup cannot be resolved: #{attr_group.ref}"
      end
      attr_group._ref_target = target

    else
      raise 'internal error: bad attributeGroup'
    end
  end

  def preprocess_simpleType(simple_type)
    preprocess_restriction(simple_type.restriction)
  end

  def preprocess_restriction(restriction)
    # do nothing
  end

  def preprocess_simpleContent(simple_content)
    preprocess_extension(simple_content.extension)
  end

  def preprocess_extension(ext)
    ext.attribute.each do |attr|
      preprocess_attribute(attr)
    end

    ns, localname = expand_qname(ext, ext.base)
    target = collection.find_type(ns, localname)
    if ! target
      raise "extension base cannot be resolved: #{ext.base}"
    end
    ext._type_target = target
    # TODO: only allow simple types to be base types
  end

  def is_multiples?(particle)
    max = particle._maxOccurs
    max ? 1 < max : true # true if (1 < maxOccurs OR maxOccurs is unbounded)
  end

  def preprocess_particle(particle)

    min_str = particle.minOccurs
    if ! min_str
      min_value = 1 # default minOccurs
    else
      if min_str !~ /^[1-9]\d?$/ && min_str != '0'
        raise "bad minOccurs value: #{@min_str}"
      end
      min_value = Integer(min_str)
    end

    max_str = particle.maxOccurs
    if ! max_str
      max_value = 1 # default maxOccurs
    elsif max_str == 'unbounded'
      max_value = nil # nil means unbounded
    else
      if max_str !~ /^[1-9]\d?$/ && max_str != '0'
        raise "bad maxOccurs value: #{@max_str}"
      end
      max_value = Integer(max_str)
    end

    particle._minOccurs = min_value
    particle._maxOccurs = max_value
  end

  def preprocess_sequence(seq, hint=nil)

    # TODO: preprocess_particle(seq)

    # Generate a unique name for this sequence

    if hint
      base = "in_#{hint}"
      if @sequence_name_bases_used[base]
        root = base
        count = 0
        begin
          count += 1
          base = "#{root}#{count}"
        end while @sequence_name_bases_used[base]
      end
    else
      begin
        @sequence_name_count += 1
        base = @sequence_name_count.to_s
      end while @sequence_name_bases_used[base]
    end

    @sequence_name_bases_used[base] = true

    seq._module_name = @module_name
    seq._class_name = ncname_to_classname(:sequence, base)
    seq._member_name = ncname_to_membername(:sequence, base)

    # Preprocess of every member in the sequence
    # At the same time assign _member_name for all the choices
    # to be 'choice1', 'choice2', 'choice3', etc.

    choice_count = 0
    last_choice = nil

    seq.choice.each do |member|
      case member._option
      when :element
        preprocess_element(member.element)
      when :choice
        preprocess_choice(member.choice, seq._class_name)
        choice_count += 1
        member.choice._member_name = "choice#{choice_count}"
        last_choice = member.choice
      when :sequence
        preprocess_sequence(member.sequence)
      else
        raise 'internal error: invalid sequence'
      end
    end

    if choice_count == 1
      # There is only one choice in the sequence, so use the simpler
      # member name of 'choice' instead of the more cumbersome
      # member name of 'choice1'.
      last_choice._member_name = 'choice'
    end

  end

  def preprocess_choice(ch, hint=nil)

    preprocess_particle(ch)

    # Generate a unique name for this choice

    if hint
      base = "in_#{hint}"
      if @choice_name_bases_used[base]
        root = base
        count = 0
        begin
          count += 1
          base = "#{root}#{count}"
        end while @choice_name_bases_used[base]
      end
    else
      begin
        @choice_name_count += 1
        base = @choice_name_count.to_s
      end while @choice_name_bases_used[base]
    end

    @choice_name_bases_used[base] = true

    # Set the names

    ch._module_name = @module_name
    ch._class_name = ncname_to_classname(:choice, base)
    ch._member_name = ncname_to_membername(:choice, base)

    # Recursively preprocess each option in the choice

    ch.choice.each do |item|
      case item._option
      when :element
        preprocess_element(item.element)
      when :sequence
        preprocess_sequence(item.sequence)
      when :choice
        preprocess_choice(item.choice)
      else
        raise 'internal error: invalid choice'
      end
    end

  end

  def preprocess_complexType(ct, hint=nil)

    # Determine names

    base = ct.name

    if ! base
      # Generate a unique name for this complexType
      if hint
        base = "for_#{hint}"
        if @complexType_name_bases_used[base]
          root = base
          count = 0
          begin
            count += 1
            base = "#{root}#{count}"
          end while @complexType_name_bases_used[base]
        end
      else
        begin
          @complexType_name_count += 1
          base = @complexType_name_count.to_s
        end while @complexType_name_bases_used[base]
      end

      @complexType_name_bases_used[base] = true
    end

    ct._module_name = @module_name
    ct._class_name = ncname_to_classname(:complexType, base)

    # Classify it

    classify_complexType(ct)

    # Recursively preprocess content model

    case ct._form
    when :complexType_simpleContent
      preprocess_simpleContent(ct.choice1.simpleContent)
    when :complexType_sequence
      preprocess_sequence(ct.choice1.sequence, ct._class_name)
    when :complexType_choice
      preprocess_choice(ct.choice1.choice, ct._class_name)
    when :complexType_empty
      # do nothing
    else
      raise "internal error: #{ct._form}"
    end

    # Recursively preprocess attribute model

    ct.choice2.each do |item|
      case item._option
      when :attribute
        preprocess_attribute(item.attribute)
      when :attributeGroup
        preprocess_attributeGroup(item.attributeGroup)
      else
        raise 'internal error: invalid complexType (2)'
      end
    end

  end

  def preprocess_element(element)

    preprocess_particle(element)

    classify_element(element)

    # Preprocess the type

    if element._form == :element_type
      raise 'internal error' if ! element.type_attribute

      namespace, localname = expand_qname(element, element.type_attribute)

      target = collection.find_type(namespace, localname)
      if ! target
        raise "type cannot be resolved: #{element.type_attribute}"
      end
      element._type_target = target
    end

    if element._form == :element_ref
      # Set the _ref_target

      raise 'internal error' if ! element.ref

      namespace, localname = expand_qname(element, element.ref)

      target = collection.find_element(namespace, localname)
      if ! target
        raise "element ref cannot be resolved: #{element.ref}"
      end

      element._ref_target = target
    end

    # Set the _class_name and _member_name for the element

    if (element._form == :element_type ||
        element._form == :element_anonymous_complexType ||
        element._form == :element_empty)
      raise 'internal error' if ! element.name

      # Set member name based on the provided name
      element._module_name = @module_name
      element._member_name = ncname_to_membername(:element, element.name)

    else
      raise 'internal error' if element._form != :element_ref

      # Set the class and member names based on the name of the referenced element
#foobar
      # TODO: this currently uses the ref's raw name instead of
      # the preprocessed _class_name or _member_name of it.
      # This is because the referenced element might not have
      # been preprocessed yet. This code should be changed to
      # recursively preprocess that refrence (if it hasn't been
      # preprocessed yet) or to perform preprocessing in two passes.

      # This won't work if the dependences have not been seen yet.
      # This is what we really want to say:
      # element._class_name = class_name_get(ref_target_get(element))
      # element._member_name = (ref_target_get(element))._member_name
    end

    # Preprocess anonymous complexType

    if element._form == :element_anonymous_complexType
      raise 'internal error' if ! element.choice.complexType
      preprocess_complexType(element.choice.complexType, element._member_name)
    end
  end

  #================================================================
  # Code generation methods

  public

  # Create Ruby code for this XML namespace.

  def generate_code(verbose)

    output_ruby_header
    output_ruby_classes
    output_parser_common_code
    generate_parser
    output_ruby_footer
  end

  #----------------------------------------------------------------

  def output_ruby_header

    puts <<"END_HEADER1"
#!/usr/bin/ruby -w
#
# :title: #{module_name}: objects for XML namespace #{namespace}
#
# = #{module_name}
#
# This module defines classes to represent an XML infoset
# for the XML namespace:
#
#   #{namespace}
#
# It also defines methods to parse an XML document into those
# objects and to serialize those objects into an XML document.
#
# Use the parse method to convert an XML document (from either
# a +File+ or a +String+) into objects.
#
# Invoke the +xml+ method on an object to serialize it into XML.
#
END_HEADER1

    top_elements = []

    @named_elements.sort.each do |ename, item|
      ns, name, parse_method = element_info(item)
      top_elements << [ ename, parse_method ]
    end

    if ! top_elements.empty?

      puts "# == Methods to parse for elements"
      puts "#"

      top_elements.each do |e|
        puts "# <code>#{e[1]}</code>::"
        puts "#   the <code>#{e[0]}</code> element"
      end
      puts "#"

      puts <<"END_HEADER2"
# == Examples
#
# === Parsing for a specific element
#
#   file = File.new("example.xml")
#   doc = REXML::Document.new(file)
#   root_node = doc.root
#   root_element = #{module_name}#{top_elements[0][1]}(root_node) # parsing for the #{top_elements[0][0]} element
#
# === Parsing for any element declared at the top level
#
#   file = File.new("example.xml")
#   doc = REXML::Document.new(file)
#   obj, name = #{module_name}.parser(doc.root)
#   if name != 'expectedRootElementName'
#     ... # root element matched some other element
#   end
#
#   src.xml($stdout)
#
# === Error handling
#
#   begin
#     elem = #{module_name}#{top_elements[0][1]}(root_node)
#   rescue InvalidXMLError => e
#     ... # schema validity error
#   rescue REXML:...
#     ... # well-formed XML error
#   end
END_HEADER2
    end

    puts "#--"
    puts "# GENERATED CODE: DO NOT EDIT"
    puts
    puts "require 'REXML/document'"
    puts "require 'xmlobj/XSDPrimitives'"
    puts

    puts "module #{module_name}"

    puts <<"END_HEADER3"

#{COMMENT_SEPARATOR}

# Target XML namespace this module represents.
NAMESPACE='#{namespace}'

#{COMMENT_SEPARATOR}

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
        raise "unknown namespace for QName \"#\{qname}\""
      end
    end
    [ ns, localname ]

END_HEADER3
    puts '  end'
    puts 'end'
    puts
  end # output_ruby_header

  #----------------------------------------------------------------

  def output_ruby_footer
    puts "end"
    puts
    puts "#EOF"
  end

  #----------------------------------------------------------------

  def output_ruby_classes

    # All the things that have classes can be found (recursively) from
    # the top level complexType definitions and top level element
    # declarations (for those that are defined by an anonymous
    # complexType).

    @named_complexTypes.sort.each do |name, item|
      output_ruby_classes_complexType(item)
    end

    @named_elements.sort.each do |name, element|
      if element._form == :element_anonymous_complexType
        output_ruby_classes_complexType(element.choice.complexType)
      end
    end

  end

  # Generate class for a choice (or two classes for
  # choices that can repeat.

  def output_ruby_classes_choice(ch)

    puts COMMENT_SEPARATOR_CLASSES
    puts
    puts "# Class to represent a choice."
    puts "#"
    puts "# The choice's option can be determined by the _option method, which"
    puts "# will return one of the symbols in the NAMES array. The value of"
    puts "# that option can be obtained by calling [] with that symbol or the"
    puts "# method with the same name as the symbol. Only one option of the"
    puts "# choice will be chosen: attempting to obtain the values of any"
    puts "# other option will return +nil+."
    puts "#"
    puts "class #{ch._class_name} < Base"

    # Symbol table for the options of this choice

    puts "  # Names for the options in this choice."
    print "  NAMES = ["
    ch.choice.each do |el_se_ch|

      case el_se_ch._option
      when :element
        identifier = el_se_ch.element._member_name
      when :sequence
        identifier = el_se_ch.sequence._member_name
      when :choice
        identifier = el_se_ch.choice._member_name
      else
        raise 'internal error'
      end

      print " :#{identifier},"
    end
    puts "]"
    puts

    # Standard methods for a choice: initialize, _option, [], []=

    puts <<"END_OPTION_METHODS"
  def initialize(node)
    super(node)
    @_index = nil # indicates which option (0..#{ch.choice.length - 1} or nil)
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

  # Named accessor methods

  puts "  # Named accessors"
  puts

  count = 0
  ch.choice.each do |el_se_ch|

    case el_se_ch._option
    when :element
      identifier = el_se_ch.element._member_name
      cname = el_se_ch.element._class_name
    when :sequence
      identifier = el_se_ch.sequence._member_name
      cname = el_se_ch.sequence._class_name
    when :choice
      identifier = el_se_ch.choice._member_name
      cname = el_se_ch.choice._class_name
    else
      raise 'internal error'
    end

    puts "  # Get the value of option +#{identifier}+. Returns a <code>#{cname}</code> object. Returns +nil+ if not the option."
    puts "  def #{identifier}"
    puts "    #{count} == @_index ? @_value : nil"
    puts "  end"

    puts "  # Set the choice to be the +#{identifier}+ option with the +value+. The value needs to be a <code>#{cname}</code> object."
    puts "  def #{identifier}=(value)"
    puts "    @_index = #{count}"
    puts "    @_value = value"
    puts "  end"
    puts
    count += 1
  end

=begin
  # Match method

  puts "def self.match(node)"
  first = true
  element.each do |e|

    if e.type
      ename = e.name
    elsif ! e.complexType.empty?
      ename = e.name
    elsif e.ref
      target = context.find_element(e.ref_local, e.ref_ns)
      ename = target.name
    else
      raise
    end
    print first ? "  if" : "  elsif"
    puts " node.name == '#{ename}' && node.namespace == #{context.current.module_name}::NAMESPACE"
    puts "    true"
    first = false
  end
  if ! first
    puts "  else"
    puts "    false"
    puts "  end"
  else
    puts "  false # choice has no options, so never matches"
  end
  puts "end # def match"
  puts

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
  puts "end # class #{XSD::PREFIX_CLASS_CH}#{@internal_class_name}"
  puts

  if multiples?
    # This choice is repeatable, so create a class to hold a list of them

    puts "#"
    puts "# An array of #{XSD::PREFIX_CLASS_CH}#{@internal_class_name}"
    puts "#"
    puts "class #{XSD::PREFIX_CLASS_CH_LIST}#{@internal_class_name} < Array"
    puts
    puts "  # Serialize repeatable choices as XML"
    puts "  def xml(out, indent)"
    puts "    self.each { |opt| opt.xml(out, indent) }"
    puts "  end"
    puts

    # Class finish

    puts "end # class #{ct._class_name}"
    puts

    # Recursively for nested subcomponents

      @element.each { |x| x.generate_classes(context) }
    # Recurse for nested subcomponents

    case ch._form
    when :choice_sequence
      output_ruby_classes_sequence(ct.choice1.sequence)
    when :complexType_choice
      output_ruby_classes_choice(ct.choice1.choice)
    when :complexType_simpleType
    when :complexType_empty
    else
      raise 'internal error'
    end
=end
  puts 'end'
  puts

  # Recurse for nested subcomponents

  ch.choice.each do |el_se_ch|
    case el_se_ch._option
    when :element
      output_ruby_classes_element(el_se_ch.element)
    when :sequence
      raise 'not supported yet'
    when :choice
      raise 'not supported yet'
    else
      raise 'internal error'
    end
  end

end

  def output_ruby_classes_complexType(ct)

    puts COMMENT_SEPARATOR_CLASSES
    puts
    if ct.name
      print '# Class to represent the complexType'
      print ': <code>'
      print ct.name
      print '</code>.'
    else
      print '# Class to represent an anonymous complexType.'
    end
    puts
    puts '#'
    puts "class #{ct._class_name} < Base"

    output_accessors_complexType_attr(ct)
    output_accessors_complexType_content(ct)

    puts "  def initialize(node)"
    puts "    super(node)"
    output_initialize_complexType_attr(ct)
    output_initialize_complexType_content(ct)
    puts "  end"
    puts

    puts "end"
    puts

    # Recurse for nested subcomponents

    case ct._form
    when :complexType_simpleContent
      # do nothing
    when :complexType_sequence
      output_ruby_classes_sequence(ct.choice1.sequence)
    when :complexType_choice
      output_ruby_classes_choice(ct.choice1.choice)
    when :complexType_empty
    else
      raise "internal error: #{ct._form}"
    end

  end

  def output_ruby_classes_element(elem)

    # Although elements don't have classes associated with them
    # (because they will be represented by the class of their
    # datatype), there might be nested subcomponents that
    # require classes to be defined.

    # Recurse for nested subcomponents

    case elem._form
    when :element_type
      # class will be created by that type's definition
    when :element_ref
      # class will be created by the reference's declaration
    when :element_anonymous_complexType
      output_ruby_classes_complexType(elem.choice.complexType)
    else
      raise "internal error: #{elem._form}"
    end

  end

  def output_accessor_sequence_choice(choice)

    # Get the name of the class for the choice

    defining_classname = choice._class_name

    # Output comment

    if is_multiples?(choice)
      # A repeatable choice
      print "  # An array of ["
      print choice._minOccurs
      print '..'
      if choice._maxOccurs
        print choice._maxOccurs
      else
        print '*'
      end
      puts "] <code>#{defining_classname}</code> objects."

    else
      # A singular choice
      print "  # An instance of <code>#{defining_classname}</code>"
      if choice._minOccurs.zero?
        puts ' (optional choice, can be +nil+).'
      else
        puts ' (mandatory choice, always has a non-nil value).'
      end
    end

    # The accessor

    puts "  attr_accessor :#{choice._member_name}"
  end

  def output_accessor_sequence_element(element)

    # Get the name of the class for the element

    defining_classname = element._class_name

#    case element._form
#    when :element_type
#      defining_classname = type_target_get(element)._class_name
#    when :element_ref
#      raise "TODO"
#    when :element_anonymous_complexType
#      defining_classname = element.choice.complexType._class_name
#    when :element_empty
#      raise "TODO"
#    else
#      raise 'internal error'
#    end

    # Output comment

    if is_multiples?(element)
      # A repeatable element
      print "  # An array of ["
      print element._minOccurs
      print '..'
      if element._maxOccurs
        print element._maxOccurs
      else
        print '*'
      end
      puts "] <code>#{defining_classname}</code> objects."

    else
      # A singular choice
      print "  # An instance of <code>#{defining_classname}</code>"
      if element._minOccurs.zero?
        puts ' (optional element, can be +nil+).'
      else
        puts ' (mandatory element, always has a non-nil value).'
      end
    end

    # The accessor

    puts "  attr_accessor :#{element._member_name}"
  end

  def output_initialize_sequence_choice(ch)

    m_name = ch._member_name

    if is_multiples?(ch)
      init_value = '[]'
    else
      init_value = 'nil'
    end

    puts "    @#{m_name} = #{init_value}"
  end

  def output_initialize_sequence_element(element)

    m_name = element._member_name

    if is_multiples?(element)
      init_value = '[]'
    else
      init_value = 'nil'
    end

    puts "    @#{m_name} = #{init_value}"
  end


  def output_ruby_classes_sequence(seq)

    puts COMMENT_SEPARATOR_CLASSES
    puts
    puts "# Class to represent a sequence."
    puts "#"
    puts "class #{seq._class_name} < Base"

    # Accessors

    seq.choice.each do |member|
      case member._option
      when :element
        output_accessor_sequence_element(member.element)
      when :sequence
        raise # sequence of sequences not implemented yet
      when :choice
        output_accessor_sequence_choice(member.choice)
      else
        raise 'internal error'
      end
    end

    # Initializer

    puts "  def initialize(node)"
    puts "    super(node)"
    seq.choice.each do |member|
      case member._option
      when :element
        output_initialize_sequence_element(member.element)
      when :sequence
        raise # sequence of sequences not implemented yet
      when :choice
        output_initialize_sequence_choice(member.choice)
      else
        raise 'internal error'
      end
    end
    puts "  end"

    # End of class

    puts "end"
    puts

    # Recurse for nested subcomponents of this sequence

    seq.choice.each do |member|
      case member._option
      when :element
        output_ruby_classes_element(member.element)
      when :sequence
        output_ruby_classes_sequence(member.sequence)
      when :choice
        output_ruby_classes_choice(member.choice)
      else
        raise 'internal error'
      end
    end

  end # def output_ruby_classes_complexType

  def output_accessors_attribute(attr)
    puts "  # The <code>#{attr.name}</code> attribute."
    puts "  attr_accessor :#{attr._member_name}"
  end

  # Method used by both otput_accessors_attributeGroup
  # and output_accessors_complexType_attr to process
  # an option that could either be an attribute
  # or an attributeGroup.

  def output_accessors_a_or_ag(opt)
    case opt._option
    when :attribute
      output_accessors_attribute(opt.attribute)
    when :attributeGroup
      if opt.attributeGroup._form != :attributeGroup_ref
        raise "internal error: #{opt.attributeGroup._form}"
      end
      output_accessors_attributeGroup(opt.attributeGroup._ref_target)
    else
      raise 'internal error'
    end
  end

  def output_accessors_attributeGroup(ag)
    ag.choice.each do |opt|
      output_accessors_a_or_ag(opt)
    end
  end

  def output_accessors_complexType_attr(ct)

    if ct._form == :complexType_simpleContent
      # The attributes are defined inside the simpleContent
      output_accessors_simpleContent_attr(ct.choice1.simpleContent)

    else
      # The attributes are defined in the list of attribute or
      # attributeGroup at the end of the complexType definition.
      ct.choice2.each do |opt|
        output_accessors_a_or_ag(opt)
      end
    end
  end

  def output_accessors_simpleContent_attr(sc)
     output_accessors_extension_attr(sc.extension)
  end

  def output_accessors_extension_attr(ext)
    ext.attribute.each do |attr|
      puts "  # The <code>#{attr.name}</code> attribute."
      puts "  attr_accessor :#{attr._member_name} # attribute from extension"
    end
    puts
  end

  def output_initialize_simpleContent_attr(sc)
     output_initialize_extension_attr(sc.extension)
  end

  def output_initialize_attribute(attr)
    puts "    # Attribute"
    puts "    @#{attr._member_name} = nil"
  end

  def output_initialize_attributeGroup(ag)
    ag.choice.each do |opt|
      output_initialize_a_or_ag(opt)
    end
  end

  # Method used to output the initializer code for attribute members.
  #
  # This is used by both output_initialize_complexType and
  # output_initialize_attributeGroup since both complexTypes and
  # attributeGroups contain a sequence that is a mixture of either
  # attribute or attributeGroup declarations.

  def output_initialize_a_or_ag(opt)
    case opt._option
    when :attribute
      output_initialize_attribute(opt.attribute)
    when :attributeGroup
      if opt.attributeGroup._form != :attributeGroup_ref
        raise 'internal error'
      end
      output_initialize_attributeGroup(opt.attributeGroup._ref_target)
    else
      raise 'internal error'
    end
  end

  def output_initialize_extension_attr(ext)
    ext.attribute.each do |attr|
      puts "    @#{attr._member_name} = nil"
    end
    puts
  end

  def output_initialize_complexType_attr(ct)

    if ct._form == :complexType_simpleContent
      # The attributes are defined inside the simpleContent
      output_initialize_simpleContent_attr(ct.choice1.simpleContent)

    else
      # The attributes are defined in the list of attribute or
      # attributeGroup at the end of the complexType definition.
      ct.choice2.each do |opt|
        output_initialize_a_or_ag(opt)
      end
    end
  end

  #----------------

  # Create code to declare the accessors for the content model for a
  # ComplexType.

  def output_accessors_complexType_content(ct)

    case ct._form
    when :complexType_simpleContent
      output_accessor_simpleContent_content(ct.choice1.simpleContent)
    when :complexType_sequence
      output_accessor_complexType_sequence(ct.choice1.sequence)
    when :complexType_choice
      output_accessor_complexType_content_choice(ct.choice1.choice)
    when :complexType_empty
      # No accessors
    else
      raise 'internal error'
    end
  end

  # Create code to declare the accessors for the content model for a
  # ComplexType with sequence.

  def output_accessor_complexType_sequence(seq)

    puts "  # For internal use by parsers."
    puts "  #"
    puts "  # An instance of <code>#{seq._class_name}</code>"
    puts "  # to represent the sequence which defines the content model"
    puts "  # of this complexType. Users of this class will invoke"
    puts "  # the methods of the sequence that have been replicated"
    puts "  # by this class: they do not directly access the sequence."
    puts "  attr_writer :_sequence"
    puts
    puts "  # Since this is a complexType defined by a sequence,"
    puts "  # the members of that sequence can be accessed through"
    puts "  # the following getters and setters. They invoke the"
    puts "  # corresponding method on the _sequence object, so"
    puts "  # the user doesn't have to interact with the underlying"
    puts "  # _sequence at all."
    puts
    # The user does not (and cannot) interact with the complexType's
    # sequence directly, since seeing that extra layer is inconvenient
    # and provides no real benefits. If you want to allow them to
    # access the sequence object, change the above attr_writer into an
    # attr_accessor.

    seq.choice.each do |member|
      case member._option

      when :element
        # Redirect accessors to the members of the sequence
        n = member.element._member_name

        desc = ''
        if is_multiples?(member.element)
          desc << " An array of <code>"
        else
          desc << " A single <code>"
        end
        desc << member.element._class_name
        desc << '</code>.'
        if member.element._minOccurs.zero?
          if is_multiples?(member.element)
            desc << ' Can be an empty array.'
          else
            desc << ' Optional, so could be +nil+.'
          end
        else
          if is_multiples?(member.element)
            desc << ' Has a minimum length of #{member.element.minOccurs}.'
          else
            desc << ' Mandatory, so is never +nil+.'
          end
        end

        puts "  # Gets the child <code>#{n}</code>. #{desc}"
        puts "  def #{n}; @_sequence.#{n} end"

        puts "  # Sets the child <code>#{n}</code>. #{desc}"
        puts "  def #{n}=(value); @_sequence.#{n}(value) end"
        puts

      when :sequence
        raise 'not implemented yet' # so far all our schemas only have elements as the options of a choice

      when :choice
        # Redirect accessors to the members of the sequence
        n = member.choice._member_name

        desc = ''
        if is_multiples?(member.choice)
          desc << " An array of <code>"
        else
          desc << " A single <code>"
        end
        desc << member.choice._class_name
        desc << '</code>.'
        if member.choice._minOccurs.zero?
          if is_multiples?(member.choice)
            desc << ' Can be an empty array.'
          else
            desc << ' Optional, so could be +nil+.'
          end
        else
          if is_multiples?(member.choice)
            desc << ' Has a minimum length of #{member.choice.minOccurs}.'
          else
            desc << ' Mandatory, so is never +nil+.'
          end
        end

        puts "  # Gets the child <code>#{n}</code>. #{desc}"
        puts "  def #{n}; @_sequence.#{n} end"

        puts "  # Sets the child <code>#{n}</code>. #{desc}"
        puts "  def #{n}=(value); @_sequence.#{n}(value) end"
        puts

      else
        raise 'internal error'
      end
    end

  end # def

  # Create code to declare the accessors for the content model for a
  # ComplexType with choice.

  def output_accessor_complexType_content_choice(choice)

    if is_multiples?(choice)
      # A repeatable choice
      print "  # An array of ["
      print choice._minOccurs
      print '..'
      if choice._maxOccurs
        print choice._maxOccurs
      else
        print '*'
      end
      puts "] <code>#{choice._class_name}</code> objects."

      puts "  attr_accessor :_choices"

      # Cannot redirect accessor to the options

    else
      # A singular choice
      print "  # The <code>#{choice._class_name}</code> object"
      if choice._minOccurs.zero?
        puts ' (optional choice, can be +nil+).'
      else
        puts ' (mandatory choice, always has a non-nil value).'
      end

      puts "  attr_writer :_choice"

      # Redirect accessors to the options of the choice for convenience
      choice.choice.each do |ch|
        case ch._option
        when :element
          # TODO
#        n = opt.internal_name
        puts "  # The choice's get option"
#        puts "  def #{n}; @_choice.#{n} end"
        puts "  # The choice's set option"
#        puts "  def #{n}=(value); @_choice.#{n}(value) end"
        when :sequence
          # TODO
        when :choice
          # TODO
        else
          raise 'internal error'
        end
      end
    end
  end


  def output_accessor_simpleContent_content(sc)
    output_accessors_extension_content(sc.extension)
  end

  def output_accessors_extension_content(ext)
    puts "  # The simpleContent value as a +String+."
    puts "  # In XML Schema, this is an extension of <code>#{ext.base}</code>."
    puts "  attr_accessor :_value"
    puts
  end


  def output_initialize_complexType_content(ct)

    case ct._form
    when :complexType_simpleContent
      output_initialize_simpleContent_content(ct.choice1.simpleContent)
    when :complexType_sequence
      output_initialize_complexType_sequence(ct.choice1.sequence)
    when :complexType_choice
      output_initialize_complexType_content_choice(ct.choice1.choice)
    when :complexType_empty
      # No accessors
    else
      raise 'internal error'
    end
  end

  def output_initialize_complexType_sequence(seq)
    puts "    @_sequence = nil"
  end # def

  def output_initialize_complexType_content_choice(choice)
    if is_multiples?(choice)
      puts "    @_choices = []"
    else
      puts "    @_choice = nil"
    end
  end

  def output_initialize_simpleContent_content(sc)
    output_initialize_extension_content(sc.extension)
  end

  def output_initialize_extension_content(ext)
    puts "    @_value = nil"
  end

  #================================================================
  # Parser code

  #----------------------------------------------------------------

  def generate_parser
    @named_attributeGroups.keys.sort.each do |name|
      generate_parser_attributeGroup(@named_attributeGroups[name], true)
    end
    @named_complexTypes.keys.sort.each do |name|
      generate_parser_complexType(@named_complexTypes[name], true)
    end

    @named_elements.keys.sort.each do |name|
      generate_parser_element(@named_elements[name], true)
    end

    if ! @named_elements.empty?
      output_top_parser_method
    end

  end

  #----------------------------------------------------------------
  # Outputs the common code that is used by the parsing methods.

  def output_parser_common_code

  puts <<"END_PARSER_COMMON"
  #{COMMENT_SEPARATOR}

  # Exception raised when parsing XML and it violates the XML Schema.
  #
  class InvalidXMLError < Exception; end

  #{COMMENT_SEPARATOR}
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
      raise InvalidXMLError, "mandatory attribute missing: \#{name}"
    end
    a.value
  end

  # Parses an empty element. Such elements contain no attributes
  # and no content model.
  def self.#{PREFIX_PARSE}element_empty(node)
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
  #
  def self.expecting_whitespace(node)
    if node.to_s !~ /^\s*$/
      raise InvalidXMLError, "Unexpected text: \#{node.to_s.strip}"
    end
  end

#{COMMENT_SEPARATOR}
# Parsing methods

END_PARSER_COMMON
end

  #================================================================

  # Output code fragment for parsing an attribute.

  def gen_parser_attribute(attr, node_name, result_name)

#    if @name
#      aname = @name
#      member_name = @internal_name
#    elsif @ref
#      if @ref == 'xml:lang'
#        aname = 'lang' # FIXME
#        member_name = 'lang'
#      else
#        aname = @ref # FIXME
#        member_name = @ref # FIXME
#      end
#    else
#      raise "attribute without a name or a ref"
#    end
    aname = attr.name

    print "    #{result_name}.#{attr._member_name} = "

    if attr.use == nil || attr.use == 'optional'
      puts "attr_optional(#{node_name}, '#{aname}')"
    elsif attr.use == 'required'
      puts "attr_required(#{node_name}, '#{aname}')"
    else
      raise "TODO"
    end
  end

  #----------------------------------------------------------------

  def gen_parser_attributeGroup(attr_group)
    puts "  #{PREFIX_PARSE}#{attr_group._class_name}(node, result)"
  end

  def generate_parser_attributeGroup(attr_group, is_top)

    if is_top
      puts "public"
    else
      raise # aren't all attributeGroup declaration top level?
    end

    puts "# Parser for attributeGroup: #{attr_group.name}"
    puts "def self.#{PREFIX_PARSE}#{attr_group._class_name}(node, result)"
    attr_group.choice.each do |opt|
      case opt._option
      when :attribute
        gen_parser_attribute(opt.attribute, 'node', 'result')
      when :attributeGroup
        raise 'TODO'
      end
    end

    puts "end"
    puts
  end

  #----------------------------------------------------------------

def gen_parser_simpleContent(sc, node_name, result_name)

  gen_parser_extension(sc.extension, node_name, result_name)
end

#----------------------------------------------------------------

def gen_parser_extension(ext, node_name, result_name)

  puts "  begin # extension parsing"

  # Parse attributes

  puts "    # Parse extension's attributes"
  ext.attribute.each do |attr|
    gen_parser_attribute(attr, node_name, result_name)
  end

  # Parse base

  parse_method = ''
  if ext._type_target._module_name != @module_name
    # Class defined in a different module
    parse_method << ext._type_target._module_name
    parse_method << '.'
  end
  parse_method << PREFIX_PARSE
  parse_method << ext._type_target._class_name

  puts "    # Parse extension's base"
  puts "    #{result_name}._value = #{parse_method}(#{node_name})"

  puts "  end"
end

#----------------------------------------------------------------
# Sequence

def gen_if_match_sequence(context, node_name)
  "#{XSD::PREFIX_CLASS_SE}#{internal_name}.match(#{node_name})"
end

# Creates code used to parse this sequence as a particle

def gen_sequence_match_code(context, vname)
  "#{PREFIX_PARSE}#{seq._class_name}(#{vname}, offset)"
end

def generate_parser_sequence(seq)

  # Generate for nested subcomponents of this sequence

  seq.choice.each do |member|
    case member._option
    when :element
      generate_parser_element(member.element, false)
    when :sequence
      raise # TODO
    when :choice
      generate_parser_choice(member.choice)
    else
      raise 'internal error'
    end
  end

  # Generate parser for this sequence

  puts "private"
  puts "# Parser for a sequence."
  puts "# Starting at the +offset+ node in the +nodes+ array."
  puts "# Returns matched object and next offset index after parsed nodes."
  puts "def self.#{PREFIX_PARSE}#{seq._class_name}(nodes, offset)"
  puts
  puts "  result = #{seq._class_name}.new(nil)"
  puts
  puts "  # Parse sequence"
  puts "  state = 0"
  puts "  while offset < nodes.size"
  puts "    child = nodes[offset]"
  puts
  puts "    if child.is_a?(REXML::Element)"
  puts "      case state"

  state_count = 0
  last_required = nil

  seq.choice.each do |member|
    case member._option
    when :element
      gen_parser_sequence_element(member.element, state_count)
      state_count += 1
      if member.element._minOccurs != 0
        last_required = member
      end

    when :sequence
      raise # TODO: sequence inside sequence

    when :choice
      gen_parser_sequence_choice(member.choice, state_count)
      state_count += 1
      if member.choice._minOccurs != 0
        last_required = member
      end
    else
      raise 'internal error'
    end
  end

  puts "      else"
  puts "        raise InvalidXMLError, \"unexpected element: {\#{child.namespace}}\#{child.name}\""
  puts "      end"

  puts "    elsif child.is_a?(REXML::Text)"
  puts "      expecting_whitespace child"
  puts "      offset += 1"
  puts "    elsif child.is_a?(REXML::Comment)"
  puts "      # Ignore comments"
  puts "      offset += 1"
  puts "    else"
  puts "      raise InvalidXMLError, \"internal error: unsupported node type: \#{child.class}\""
  puts "    end"
  puts "  end"
  puts

  # Code to check for incomplete sequence

  if last_required
    # Not everything in the sequence is optional
    puts "  # Completeness check"

    case last_required._option
    when :element
      if is_multiples?(last_required.element)
        puts "  if result.#{last_required.element._member_name}.length < #{last_required.element._minOccurs}"
      else
        puts "  if ! result.#{last_required.element._member_name}"
      end
      puts "    raise InvalidXMLError, \"sequence is incomplete\""
      puts "  end"

    when :sequence
      puts "  raise \"TODO: internal error last particle in sequence is a sequence\""

    when :choice
      puts "  if result.#{last_required.choice._member_name} == nil"
      puts "    raise InvalidXMLError, \"sequence is incomplete\""
      puts "  end"

    else
      raise 'internal error'
    end

  else
    puts "  # Completeness check: not required, because all members are minOccurs=0"
  end

  puts
  puts "  # Success"
  puts "  return [result, offset]"
  puts "end"
  puts
end

def gen_parser_sequence_element(element, state_count)
  puts "      when #{state_count}"

  # The following code will be:
  #   if (node matches one instance of this member)
  #     parse the node
  #   else
  #     check minOccurs and maxOccurs constraints are satisfied
  #     advance to next state and try to parse the node in it
  #  end

  mname = element._member_name

  ns, name, parse_method = element_info(element)

  puts "        if child.name == '#{name}' && child.namespace == #{ns}"
  puts "          r, offset = #{parse_method}(nodes[offset]), offset + 1"
  if is_multiples?(element)
    puts "          result.#{mname} << r"
  else
    puts "          result.#{mname} = r"
  end

  puts "        else"

  # No match: move to next state after checking minOccurs and maxOccurs are satisfied

  if element._minOccurs.zero?
    min_check_fails = nil
  else
    min_check_fails = is_multiples?(element) ? ".length < #{element._minOccurs}" : " == nil"
  end

  if min_check_fails
    puts "          raise InvalidXMLError, \"sequence not enough #{mname}\" if result.#{mname}#{min_check_fails}"
  end

  if ! element._maxOccurs
    max_check_fails = nil # unbounded
  else
    max_check_fails = is_multiples?(element) ? ".length > #{element._maxOccurs}" : nil
  end

  if max_check_fails
    puts "          raise InvalidXMLError, \"sequence too many #{mname}\" if result.#{mname}#{max_check_fails}"
  end

  puts "          state = #{state_count + 1}"
  puts "        end"
end

def gen_parser_sequence_choice(ch, state_count)
  puts "      when #{state_count}"

  # The following code will be:
  #   if (node matches one instance of this member)
  #     parse the node
  #   else
  #     check minOccurs and maxOccurs constraints are satisfied
  #     advance to next state and try to parse the node in it
  #  end

  mname = ch._member_name

  puts "        if #{ gen_if_match_choice(ch, 'child') }"
  puts "          r, offset = #{PREFIX_PARSE}#{ch._class_name}(nodes, offset)"
  if is_multiples?(ch)
    puts "          result.#{mname} << r"
  else
    puts "          result.#{mname} = r"
  end

  puts "        else"

  # No match: move to next state after checking minOccurs and maxOccurs are satisfied

  if ch._minOccurs.zero?
    min_check_fails = nil
  else
    min_check_fails = is_multiples?(ch) ? ".length < #{ch._minOccurs}" : " == nil"
  end

  if min_check_fails
    puts "          raise InvalidXMLError, \"sequence not enough #{mname}\" if result.#{mname}#{min_check_fails}"
  end

  if ! ch._maxOccurs
    max_check_fails = nil # unbounded
  else
    max_check_fails = is_multiples?(ch) ? ".length > #{ch._maxOccurs}" : nil
  end

  if max_check_fails
    puts "          raise InvalidXMLError, \"sequence too many #{mname}\" if result.#{mname}#{max_check_fails}"
  end

  puts "          state = #{state_count + 1}"
  puts "        end"
end

#----------------------------------------------------------------
# Choice

# Creates the conditional part of an if statement to test
# if the node_name can match at least one of the options
# in the choice.

def gen_if_match_choice(ch, node_name)

#  "#{ch._class_name}.match(#{node_name})"

  str = ''

  first = true
  ch.choice.each do |option|
    str << " || \\\n           " if ! first

    case option._option
    when :element
      ns, name, unused_parse_method = element_info(option.element)
      str << "#{node_name}.name == '#{name}' && #{node_name}.namespace == #{ns}"

    else
      raise 'internal error: only elements inside choices are supported'
    end

    first = false
  end

  if first
    # Choice has no options, so it never matches
    str << "false # choice has no options, so never matches"
  end

  str # result
end



def generate_parser_choice(ch)

  # Generate for nested subcomponents

  ch.choice.each do |el_se_ch|
    case el_se_ch._option
    when :element
      generate_parser_element(el_se_ch.element)
    when :sequence
      generate_parser_sequence(el_se_ch.sequence)
    when :choice
      generate_parser_choice(el_se_ch.choice)
    else
      raise 'internal error'
    end
  end

  # Generate for this choice

  puts "private"
  puts "# Parser for choice: <code></code>"
  puts

  puts "def self.#{PREFIX_PARSE}#{ch._class_name}(nodes, offset)"

  puts "  # Create result object"

  puts "  result = #{module_name}::#{ch._class_name}.new(nil)"
  puts

  puts "  # Parse choice"

  puts "  while offset < nodes.length do"
  puts "    node = nodes[offset]"
  puts "    if node.is_a?(REXML::Element)"

  first = true
  ch.choice.each do |el_se_ch|
    case el_se_ch._option
    when :element
      gen_parser_choice_element(el_se_ch.element,
                        'node', 'offset', 'result', first)
    when :sequence
      raise 'not supported yet'
    when :choice
      raise 'not supported yet'
    else
      raise 'internal error'
    end
    first = false
  end

  puts "      else"
  puts "        raise InvalidXMLError, \"Unexpected element in choice: {\#{node.namespace}}\#{node.name}\""
  puts "      end"
  puts
  puts "    elsif node.is_a?(REXML::Text)"
  puts "      expecting_whitespace node"
  puts "      offset += 1"
  puts "    elsif node.is_a?(REXML::Comment)"
  puts "      # Ignore comments"
  puts "      offset += 1"
  puts "    else"
  puts "      raise InvalidXMLError, \"Unknown node type: \#{child.class}\""
  puts "    end"
  puts "  end"
  puts "  raise \'choice not found\'"
  puts "end"
  puts
end

def element_info(element)
  case element._form
  when :element_type
    name_def = element
    type_def = element._type_target
  when :element_ref
    name_def = element._ref_target
    type_def = element._ref_target
  when :element_anonymous_complexType
    name_def = element
    type_def = element.choice.complexType
  when :element_empty
    name_def = element
    type_def = nil #TODO
  else
    raise 'internal error'
  end

  # Determine expected element name and namespace

  if name_def._module_name == @module_name
    element_ns = 'NAMESPACE' # from this module's namespace
  else
    element_ns = "#{name_def._module_name}::NAMESPACE" # from another module's namespace
  end

  element_name = name_def.name

  # Determine parse method name

  if type_def
    parse_method = ''
    if type_def._module_name != @module_name
      # Class defined in a different module
      parse_method << type_def._module_name
      parse_method << '.'
    end
    parse_method << PREFIX_PARSE
    parse_method << type_def._class_name

  else
    raise if element._form != :element_empty
    parse_method = "#{PREFIX_PARSE}element_empty"
  end

  return [ element_ns, element_name, parse_method ]
end

def gen_parser_choice_element(element,
                      node_name, offset_name, result_name, first)

  ns, name, parse_method = element_info(element)

  # Output code

  print first ? "      if " : "      elsif "
  puts "#{node_name}.name == '#{name}' && #{node_name}.namespace == #{ns}"
  puts "        #{result_name}.#{element._member_name} = #{parse_method}(node)"
  puts "        return #{result_name}, #{offset_name} + 1"

#  case element._form
#  when :element_type
#    parse_method = PREFIX_PARSE + element._class_name
#  when :element_ref
#    parse_method = PREFIX_PARSE + element._class_name
#  when :element_anonymous_complexType
#    parse_method = PREFIX_PARSE + element.choice.complexType._class_name
#  when :element_empty
#    parse_method = PREFIX_PARSE + 'xxxxxxxx_empty'
#  else
#    raise 'internal error'
#  end



#  case element._form
#  when :element_type
#    # Named datatype
#    if opt.type == 'xsd:string'
#      parse_method = "#{PREFIX_PARSE_PR}string"
#    elsif opt.type == 'xsd:anyURI'
#      parse_method = "#{PREFIX_PARSE_PR}string" # TODO: treating anyURI as string
#    else
#      ct = context.find_complexType(opt.type_local, opt.type_ns)
#      if ! ct
#        raise "unknown complexType: #{opt.type}"
#      end
#      parse_method = "#{XSD::PREFIX_PARSE_CT}#{ct.internal_name}"
#    end
#    element_name = opt.name
#
#  when :element_ref
#    # Reference to an element declaration
#    el = context.find_element(opt.ref_local, opt.ref_ns)
#    if ! el
#      raise "unknown element reference: #{opt.ref}"
#    end
#    parse_method = "#{XSD::PREFIX_PARSE_EL}#{el.name}"
#    element_name = el.name
#
#  when :element_anonymous_complexType
#    # Anonymous complexType
#    ctname = opt.complexType[0].internal_name
#    parse_method = "#{XSD::PREFIX_PARSE_CT}#{ctname}"
#    element_name = opt.name
#
#  else
#    raise 'internal error'
#  end

end

#----------------------------------------------------------------

  def generate_parser_complexType(ct, is_top=false)

    # Generate for nested subcomponents of this complexType

    case ct._form
    when :complexType_simpleContent
      # no nested subcomponents
    when :complexType_sequence
      generate_parser_sequence(ct.choice1.sequence)
    when :complexType_choice
      generate_parser_choice(ct.choice1.choice)
    when :complexType_empty
      # no nested subcomponents
    else
      raise 'internal error'
    end

    # Generate for this complexType

    if is_top
      puts "public"
    else
      puts "private"
    end
    puts
    puts "# Parser for complexType: <code>#{ct._class_name}</code>"
    puts

    puts "def self.#{PREFIX_PARSE}#{ct._class_name}(node)"
    puts

    puts "  # Create result object"
    puts "  result = #{module_name}::#{ct._class_name}.new(node)"
    puts

    # Parse attributes

    ct.choice2.each do |opt|
      case opt._option
      when :attribute
        gen_parser_attribute(opt.attribute, 'node', 'result')
      when :attributeGroup
        gen_parser_attributeGroup(opt.attributeGroup)
      else
        raise 'internal error'
      end
    end

#    if 0 < ct.attribute.length
#      puts "  # Parse attributes"
#      ct.attribute.each do |attr|
#        gen_attribute_parser(attr, 'node', 'result')
#      end
#    end
#    if 0 < ct.attributeGroup.length
#      puts "  # Parse attributeGroups"
#      ct.attributeGroup.each do |attr_group|
#        gen_attributeGroupparser(attr_group)
#      end
#    end

    # Parse content model

    puts "  # Content model"

    case ct._form

    when :complexType_simpleContent
      gen_parser_simpleContent(ct.choice1.simpleContent, 'node', 'result')

    when :complexType_sequence
      puts "  result._sequence, offset = #{PREFIX_PARSE}#{ct.choice1.sequence._class_name}(node.children, 0)"
      puts "  if offset < node.children.size"
      puts "     raise \"complexType sequence has left over elements\""
      puts "  end"

    when :complexType_choice
      gen_parser_complexType_choice(ct.choice1.choice, 'node', 'result')

    when :complexType_empty
      gen_parser_complexType_empty('node')

    else
      raise 'internal error'
    end

    # Finish up parse method for a complexType

    puts
    puts "  # Success"
    puts "  result"
    puts "end"
    puts
  end


  def gen_parser_complexType_choice(ch, node_name, result_name)

  if is_multiples?(ch)
    puts "  # complexType with choice (repeatable)"
    puts "  #{result_name}._choices = []"
  else
    puts "  # complexType with choice (single)"
    puts "  #{result_name}._choice = nil"
  end

  # Process all children of the node

  puts "  offset = 0"
  puts "  while offset < #{node_name}.children.length"
  puts "    child = #{node_name}.children[offset]"
  puts "    if child.is_a?(REXML::Element)"

  if ! is_multiples?(ch)
    puts "      if #{result_name}._choice"
    puts "        raise InvalidXMLError, \"unexpected element in complexType choice\""
    puts "      end"
  end

#TODO  puts "      if #{XSD::PREFIX_CLASS_CH}#{ch.internal_class_name}.match(child)"
#TODO  puts "        r, offset = #{XSD::PREFIX_PARSE_CH}#{ch.internal_member_name}(#{node_name}.children, offset)"

    puts "      if #{ gen_if_match_choice(ch, 'child') }"
    puts "        r, offset = #{PREFIX_PARSE}#{ch._class_name}(#{node_name}.children, offset)"

  if is_multiples?(ch)
    puts "        #{result_name}._choices << r"
  else
    puts "        #{result_name}._choice = r"
  end

  puts "      else"
  puts "        raise InvalidXMLError, \"unexpected element in complexType's choice\""
  puts "      end"

  puts "    elsif child.is_a?(REXML::Text)"
  puts "      expecting_whitespace child"
  puts "      offset += 1"
  puts "    elsif child.is_a?(REXML::Comment)"
  puts "      # Ignore comments"
  puts "      offset += 1"
  puts "    else"
  puts "      raise InvalidXMLError, \"internal error: unsupported node type: \#{child.class}\""
  puts "    end"
  puts "  end"

  # Check cardinality

  if is_multiples?(ch)
    if ch._minOccurs != 0
      puts "  if #{result_name}._choices.length < #{ch._minOccurs}"
      puts "    raise InvalidXMLError, \"insufficient occurances of repeating choice\""
      puts "  end"
    end
    if ch._maxOccurs
      puts "  if #{ch._maxOccurs} < #{result_name}._choices.length"
      puts "    raise InvalidXMLError, \"too many occurances of repeating choice\""
      puts "  end"
    end

  else
    if ch._minOccurs != 0
      puts "  if ! #{result_name}._choice"
      puts "    raise InvalidXMLError, \"missing occurances of choice\""
      puts "  end"
    end
  end
end

def gen_parser_complexType_empty(node_name)

  # empty content model

  puts "  # Empty content model: must only contain non-significant whitespace"
  puts "  offset = 0"
  puts "  while offset < #{node_name}.children.length"
  puts "    child = #{node_name}.children[offset]"
  puts "    if child.is_a?(REXML::Element)"
  puts "      raise InvalidXMLError, \"unexpected element in empty complexType\""
  puts "    elsif child.is_a?(REXML::Text)"
  puts "      expecting_whitespace child"
  puts "      offset += 1"
  puts "    elsif child.is_a?(REXML::Comment)"
  puts "      # Ignore comments"
  puts "      offset += 1"
  puts "    else"
  puts "      raise InvalidXMLError, \"internal error: unsupported #{node_name} type: \#{child.class}\""
  puts "    end"
  puts "  end"
end

#----------------------------------------------------------------

# Generates element parsing code.

def generate_parser_element(element, is_top=false)

  # Parser for nested subcomponents of this element

  if element.choice
    case element.choice._option
    when :complexType
      generate_parser_complexType(element.choice.complexType)
    else
      raise 'internal error'
    end
  end

  # There is no additional parsing method for elements needed, because
  # they will use the parsing method for their underlying datatype,
  # unless it is a top level element.

  if is_top
    puts "public"
    puts "# Parser for top level element +#{element.name}+"
    puts "# Returns a <code>#{element._class_name}</code> object."

    ns, name, parse_method = element_info(element)

    puts "def self.#{PREFIX_PARSE}#{element.name}(element)"
    puts "  if element.name == '#{name}' && element.namespace == #{ns}"
    puts "    #{parse_method}(element)"
    puts "  else"
    puts "    raise InvalidXMLError, \"unexpected element: expecting {\#\{ns}}\#\{name}: got {\#\{element.namespace}}\#\{element.name}\""
    puts "  end"
    puts "end"
    puts
  end

end

#----------------------------------------------------------------

def output_top_parser_method
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

  @named_elements.sort.each do |name, item|
    puts "  # * <code>#{name}</code>"
  end

  puts <<"END_PARSER_MAIN2"
  #
  # === Exceptions
  # InvalidXMLError
  #
END_PARSER_MAIN2

  puts "  def self.parse(src)"
  puts "    if src.is_a? REXML::Element"
  puts "      root = src"
  puts "    elsif src.is_a? File"
  puts "      root = REXML::Document.new(src).root"
  puts "    elsif src.is_a? String"
  puts "      root = REXML::Document.new(src).root"
  puts "    else"
  puts "      e = ArgumentError.new \"\#\{__method__} expects a File, String or REXML::Element\""
  puts "      e.set_backtrace caller"
  puts "      raise e"
  puts "    end"
  puts

  first = true
  @named_elements.sort.each do |ename, item|

    ns, name, parse_method = element_info(item)
    raise 'internal error' if name != ename

    print first ? '    if ' : '    elsif '
    puts "root.name == '#{name}' && root.namespace == #{ns}"
    puts "      return [ #{parse_method}(root), '#{name}' ]"
#    puts "      return [ #{PREFIX_PARSE}#{item.name}(root), '#{name}' ]"
    first = false
  end

  puts "    else"
  puts "      raise InvalidXMLError, \"element not from namespace: \#{NAMESPACE}\""
  puts "    end"
  puts "  end"
  puts
end

#----------------------------------------------------------------

end

#EOF
