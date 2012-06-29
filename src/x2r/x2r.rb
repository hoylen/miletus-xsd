#!/usr/bin/ruby -w
#
# = XML Schema to Ruby classes
#
# A command line program to convert one or more XML Schema files into
# one or more Ruby modules.
#
# For help, run with <code>--help</code>.

require 'optparse'
require 'XSD'
require 'xsd-info-ruby'

#----------------------------------------------------------------

# Extends the XSD module with methods for managing data used
# for code generation.

class XSD::Base

  # Set by the classify_* methods for attributes, complexTypes and elements
  attr_accessor :_form

  # This is only used by attributes and elements.
  attr_accessor :_ref_target

  # This is only used by attributes and elements.
  attr_accessor :_type_target

  # The minOccurs as a number. If used, this is never +nil+.
  attr_accessor :_minOccurs
  # The maxOccurs as a number or +nil+ to represent unbounded.
  attr_accessor :_maxOccurs

  # The module name of this component.
  attr_accessor :_module_name

  # Sets the class name
  def _class_name=(n)
    @_class_name = n
  end

  # Returns the class name. How the class name is obtained depends on
  # how this component is defined. Components with an explicity type
  # will return the class name for that type. References will return
  # the referenced component's class name.

  def _class_name
    case _form
    when :element_type
      _type_target._class_name
    when :element_ref
      _ref_target._class_name
    when :element_anonymous_complexType
      choice.complexType._class_name
    when :element_empty
      'element_empty' # TODO

    when :attribute_type
      _type_target._class_name
    when :attribute_ref
      _ref_target._class_name

    when :attributeGroup_ref
      _ref_target._class_name
    when :attribute_ref
      raise 'internal error'

    else
      @_class_name
    end
  end

  def _member_name=(n)
    @_member_name = n
  end

  def _member_name
    case _form
    when :element_ref
      _ref_target._member_name
    when :attribute_ref
      _ref_target._member_name
    else
      @_member_name
    end
  end

end

#----------------------------------------------------------------

private
def generate_code(collection, outdir, verbose)

  # Preprocess

  collection.namespaces.each do |namespace|
    collection.get_info(namespace).preprocess
  end

  # Output every namespace's module into a separate file

  collection.namespaces.each do |namespace|
    info = collection.get_info(namespace)

    # Open output file

    if outdir != '-'
      # Output to file whose name is based on the module name
      begin
        filename = outdir
        filename += '/' if ! filename.end_with?('/')
        filename += info.module_name
        filename += '.rb'
        $stdout = File.open(filename, 'w');
      rescue => e
        $stderr.puts "Error: output file: #{e.message}"
        exit 1
      end

      if verbose
        $stderr.puts "Generating module for namespace #{namespace} -> #{filename}"
      end
    else
      # Output defaults to stdout (for all modules)
      if verbose
        $stderr.puts "Generating module for namespace #{namespace} -> #{filename}"
      end
    end

    # Generate code

    info.generate_code(verbose)

    # Close output file

    if outdir != '-'
      $stdout.close
    end
  end

end # def generate_code

#----------------------------------------------------------------

private
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
    $stderr.puts "Usage error: missing input schema filenames (-h for help)"
    exit 2
  end

  return [ ARGV,
           options[:verbose], options[:modules],
           options[:outdir] ]

end # def process_command_line

#----------------------------------------------------------------

public
def main

  filenames,
  verbose, module_names,
  outdir = process_command_line

  # Load XML Schemas

  collection = XSDInfoCollection.new

  filenames.each do |f|

    # Load the XML schema file

    schema, name = XSD.parse(File.new(f))
    if name != 'schema'
      $stderr.puts "Error: not an XML Schema file: #{f}"
      exit 1
    end

    # Create or add it to an XSDInfo

    info = collection.get_info(schema.targetNamespace)
    if ! info
      info = XSDInfoRuby.new(schema.targetNamespace)
      collection.add_info(info)
    end
    if ! info.add_schema(schema, f)
      $stderr.puts "Warning: schema already loaded: #{f}"
    end
  end

  # Set the module names from the command line parameter

  list_mod = module_names.split(',')
  list_ns = collection.namespaces

  if list_mod.length != list_ns.length
    $stderr.puts "Usage error: number of module names" \
    " does not match the number of unique schema namespaces:" \
    " #{list_mod.length} != #{list_ns.length}"
    exit 2
  end

  list_ns.each_index do |i|
    module_name = list_mod[i]

    # Check syntax is suitable as a Ruby module name

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

    # Set it

    info = collection.get_info(list_ns[i])
    info.module_name = module_name
  end

  # Generate code

  generate_code(collection, outdir, verbose)

  0 # success
end

exit main

#EOF
