
require 'src/xsd-datatypes'

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

class XSDInfo
  attr_accessor :namespace
  attr_accessor :collection

  def initialize(namespace)
    super()
    @namespace = namespace

    @sources = {}

    @named_attributes = {}
    @named_attributeGroups = {}
    @named_complexTypes = {}
    @named_elements = {}
  end

  def add_schema(schema, source)

    if @sources[source]
      # A schema already exists from that source, so don't
      # add it again. Do nothing.
      return
    end

    # Keep track of the sources

    @sources[source] = true

    # Keep track of the schemas
    # Note: currently we don't need this since we only
    # care about the components in the schemas
    # @schemas << schema

    # Extract and save the components from the schema

    extract_components(schema)
    self
  end

  def extract_components(schema)

    # First choice has annoation/include/import

    schema.choice1.each do |item|
      # TODO
    end

    # Second choice has attribute/attributeGroup/complexType/element

    schema.choice2.each do |item|
      case item._option
      when :attribute
        a = item.attribute
        if @named_attributes[a.name]
          raise "duplicate top level attribute: #{a.name}"
        end
        @named_attributes[a.name] = a

      when :attributeGroup
        ag = item.attributeGroup
        if @named_attributeGroups[ag.name]
          raise "duplicate attributeGroup: #{ag.name}"
        end
        @named_attributeGroups[ag.name] = ag

      when :simpleType
        raise 'TODO: top level simpleType'

      when :complexType
        ct = item.complexType
        if @named_complexTypes[ct.name]
          raise "duplicate top level complexType: #{ct.name}"
        end
        @named_complexTypes[ct.name] = ct

      when :element
        e = item.element
        if @named_elements[e.name]
          raise "duplicate top level element: #{e.name}"
        end
        @named_elements[e.name] = e

      when :annotation
        # ignore annotations

      else
        raise 'internal error'
      end
    end

  end

  #----------------

  def find_attribute(name)
    @named_attributes[name]
  end

  def find_attributeGroup(name)
    @named_attributeGroups[name]
  end

  def find_complexType(name)
    @named_complexTypes[name]
  end

  def find_element(name)
    @named_elements[name]
  end

end # class XSDInfo

#================================================================

# A collection of XSDInfo

class XSDInfoCollection

  # Array of the known namespaces (as Strings) in the order they were added.
  attr_reader :namespaces

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

  #----------------

  def add_info(info)
    ns = info.namespace

    if @data[ns]
      raise "info already exists: #{namespace}"
    end

    @namespaces << ns
    @data[ns] = info

    info.collection = self
  end

  def get_info(namespace)
    @data[namespace]
  end

  #----------------

  def find_attribute(namespace, name)
    info = @data[namespace]
    info ? info.find_attribute(name) : nil
  end

  def find_attributeGroup(namespace, name)
    info = @data[namespace]
    info ? info.find_attributeGroup(name) : nil
  end

  def find_complexType(namespace, name)
    info = @data[namespace]
    info ? info.find_complexType(name) : nil
  end

  def find_element(namespace, name)
    info = @data[namespace]
    info ? info.find_element(name) : nil
  end

  def find_type(namespace, name)
    # used by element 'type' attributes
    t = find_complexType(namespace, name)
    return t if t
    # TODO: support simpleTypes too

    if namespace == 'http://www.w3.org/2001/XMLSchema'
      t = XSD_Primitives.find_primitive(name)
    end
    return t if t

    raise "type not resolved: #{namespace} #{name}"
  end


end # class XSDInfoCollection

#EOF
