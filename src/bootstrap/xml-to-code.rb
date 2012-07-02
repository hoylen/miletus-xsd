#!/usr/bin/env ruby
# XSD compiler

$VERBOSE = true

require 'optparse'
require 'rexml/document'

#----------------------------------------------------------------

DEFAULT_PREFIX = 'XSD'

#----------------------------------------------------------------

# This is an extremely simple parser for the subset of XML Schema that
# is used by the RIF-CS schema. It does not perform any checking to
# see if the schema is correct XML Schema.
#
# The intention is that this implementation can be replaced by
# a better implementation that supports more XML Schema and
# checks for correctness. But the results will be similar:
# producing an object representation of the schema, which
# can then be used to generate Ruby code to parse instances
# of that schema.

def process_element(node)

  # Generate classes for nested sub-elements

  subvars = []
  node.elements.each do |elem|
    if (elem.name != 'annotation')
      subvars << [ elem.name, process_element(elem) ]
    end
  end

  # Create this element

  $count += 1
  var = "v#{$count}"

  puts "  #{var} = #{$prefix}::#{$prefix}_#{node.name}.new()"

  node.attributes.each_attribute do |attr|
    puts "    #{var}.#{attr.name} = \'#{attr.value}\'"
  end
  subvars.each do |subvar|
    name = subvar[0]
    value = subvar[1]
    puts "    #{var} << (#{value}) # #{name}"
  end

  puts

  var
end

#----------------------------------------------------------------

def parse_xml(files, verbose)

  doms = []

  files.each do |filename|
    $stderr.puts "Processing: #{filename}" if verbose

    begin
      doms << REXML::Document.new(File.new(filename))

    rescue REXML::ParseException => e
      $stderr.puts "#{filename}: XML not well-formed" \
      "#{verbose ? ': '+e.message : ''}"
      exit 1
    end
  end

  doms # result
end

#----------------------------------------------------------------

def generate_ruby(doms, output_filename)

  # Redirect output to output_filename (or use stdout)

  if output_filename then
    begin
      $stdout = File.open(output_filename, 'w');
    rescue => ex
      $stderr.puts "Error: output file: #{ex.message}"
      exit 1
    end
  end

  # Output header

  puts "#!/usr/bin/env ruby"
  puts
  puts "# Generated code: do not edit"
  puts

  puts "def parse_#{$prefix}"
  puts "  results = []"
  puts

  # Output code for each schema

  $count = 0
  doms.each do |dom|
    process_element(dom.root)
    puts "  results << v#{$count}"
    puts
  end

  # Output footer

  puts "  return results"
  puts "end"
  puts
  puts "#EOF"

  # Close output

  if output_filename then
    $stdout.close
  end

end

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

    opt.on("-p", "--prefix str", "prefix") do |param|
      options[:prefix] = param
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

  $prefix = options[:prefix] || DEFAULT_PREFIX

  if ARGV.empty? then
    $stderr.puts "Usage error: missing input schema filenames (-h for help)"
    exit 2
  end

  return ARGV, options[:verbose], options[:output]

end # def process_command_line

#----------------------------------------------------------------

def main

  filenames, verbose, outfile_name = process_command_line

  schemas = parse_xml(filenames, verbose)

  generate_ruby schemas, outfile_name

  return 0
end

exit main

#EOF
