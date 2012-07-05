

module XSD_Primitives


  class XSD_string
    attr_accessor :_class_module
    attr_accessor :_class_name

 #   attr_accessor :_method_name

    def initialize
      @_class_module = 'XSDPrimitives'
      @_class_name = 'string'
#      @_method_name = 'String'
    end

  end

  @primitives = {
    'string' => XSD_string.new,
    'anyURI' => XSD_string.new,
    'ID' => XSD_string.new,
    'nonNegativeInteger' => XSD_string.new
  }

  def self.find_primitive(name)
    return @primitives[name]
  end

  def self.class_name_get(item)

    if item.is_a? XSD_string
      return 'String'
    end

    raise "internal error: no class name set for #{item.class}"
  end

end

