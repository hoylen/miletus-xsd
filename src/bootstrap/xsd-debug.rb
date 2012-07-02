#!/usr/bin/env ruby

$VERBOSE = true

require 'optparse'

#================================================================
# This implementation of the XML Schema classes simply dumps them out.

module XSD

#----------------------------------------------------------------

class Base
  def initialize
    @children = Array.new
  end

  def <<(obj)
    classname = obj.class.to_s
    if classname =~ /^XSD::XSD_/ then
      classname.sub!(/^XSD::XSD_/, '')
      member = self.instance_variable_get("@#{classname}")
      if ! member then
        raise "instance variable not found in #{self.class.to_s}: #{classname}"
      end
      member << obj
    else
      raise "unexpected class name: #{classname}"
    end
  end

  def to_dump(indent='')
    attrs = []
    elems = []
    self.instance_variables.each do |sym|
      var = self.instance_variable_get(sym)
      if (var.class == Array)
        elems << sym
      else
        attrs << sym
      end
    end
    s = ''
    s << indent << self.class.to_s << " {\n"
    attrs.each do |sym|
      var = self.instance_variable_get(sym)
      s << indent << "  #{sym} = \"" << var << "\"\n"
    end
      elems.each do |sym|
      var = self.instance_variable_get(sym)
      if 0 < var.length then
        s << indent << "  #{sym} = [\n"
        var.each do |m|
          s << m.to_dump(indent + '    ')
        end
        s << indent << "  ]\n"
      end
    end
    s << indent << "}\n"
  end
end

#----------------------------------------------------------------

class XSD_import < Base
  attr_accessor :schemaLocation, :namespace
end

class XSD_schema < Base
  attr_accessor :version, :elementFormDefault, :attributeFormDefault, :targetNamespace, :xmlns, :xsd
  attr_accessor :import, :include, :attribute, :attributeGroup, :complexType, :element
  def initialize
    super()
    @import = []
    @include = []
    @attribute = []
    @attributeGroup = []
    @complexType = []
    @element = []
  end
end

class XSD_include < Base
  attr_accessor :schemaLocation
end

class XSD_attribute < Base
  attr_accessor :use, :type, :name, :ref
  attr_accessor :simpleType
  def initialize
    super()
    @simpleType = []
  end
end

class XSD_extension < Base
  attr_accessor :base
  attr_accessor :attribute
  def initialize
    super()
    @attribute = []
  end
end

class XSD_simpleContent < Base
  attr_accessor :extension
  def initialize
    super()
    @extension = []
  end
end

class XSD_complexType < Base
  attr_accessor :name
  attr_accessor :simpleContent, :sequence, :choice, :attribute, :attributeGroup
  def initialize
    super()
    @simpleContent = []
    @sequence = []
    @choice = []
    @attribute = []
    @attributeGroup = []
  end
end

class XSD_simpleType < Base
  attr_accessor :restriction
  def initialize
    super()
    @restriction = []
  end
end

class XSD_element < Base
  attr_accessor :name, :minOccurs, :maxOccurs, :type, :ref
  attr_accessor :complexType
  def initialize
    super()
    @complexType = []
  end
end

class XSD_sequence < Base
  attr_accessor :element, :choice
  def initialize
    super()
    @members = []
  end
  # Special << method for sequences
  def <<(obj)
    @members << obj
  end
end

class XSD_choice < Base
  attr_accessor :minOccurs, :maxOccurs
  attr_accessor :element
  def initialize
    super()
    @element = []
  end
end

class XSD_attributeGroup < Base
  attr_accessor :name, :ref
  attr_accessor :attribute
  def initialize
    super()
    @attribute = []
  end
end

class XSD_enumeration < Base
  attr_accessor :value
end

class XSD_restriction < Base
  attr_accessor :base
  attr_accessor :enumeration
  def initialize
    super()
    @enumeration = []
  end
end

end

#================================================================

def dump(schemas, output_filename)

  # Redirect output to output_filename (or use stdout)

  if output_filename then
    begin
      $stdout = File.open(output_filename, 'w');
    rescue => ex
      $stderr.puts "Error: output file: #{ex.message}"
      exit 1
    end
  end

  # Dump schemas

  schemas.each do |s|
    puts "#---"
    puts s.to_dump()
    puts
  end

  # Close output

  if output_filename then
    $stdout.close
  end

end # def generate_ruby

#----------------------------------------------------------------

def process_command_line

  # Specify command line options

  options = {}
  opt_parser = OptionParser.new do |opt|
    opt.banner = "Usage: PROG [options] XMLSchemaFiles"

    opt.separator "Options:"

    opt.on("-o", "--output outfile", "output file name") do |param|
      options[:output] = param
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

  if ARGV.empty? then
    # In the interim implementation that uses the preparsed code
    # instead of XML Schema files, this check is not required
    #$stderr.puts "Usage error: missing input schema filenames (-h for help)"
    #exit 2
  end

  return ARGV, options[:verbose], options[:output], options[:preparsed]

end # def process_command_line

#----------------------------------------------------------------

def main

  filenames, verbose, outfile_name, preparsed = process_command_line

  # Load XML Schema

  if preparsed then
    # Interim parsing code uses output from 'xml-to-code.rb'
    if ! filenames.empty? then
      $stderr.puts "Warning: ignoring supplied schema files, using preparsed code: #{preparsed}"
    end
    require preparsed
    schemas = parse_XSD # to be replaced
  else
    # Normal operation parses XML Schema files directly
    raise "Internal error: schema parsing not implemented yet (use --preparsed)"
  end

  # Dump the XSD

  dump(schemas, outfile_name)

  0 # success
end

exit main

#EOF
