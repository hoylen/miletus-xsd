# rakefile

require 'rdoc/task'
require 'rake/testtask'
require 'rake/clean'

OUTDIR = 'out'

XMLOBJ_DIR = "#{OUTDIR}/xmlobj"

#----------------------------------------------------------------

task :default => :generate_rifcs

# Directories

directory XMLOBJ_DIR

directory "#{XMLOBJ_DIR}/xsd-features"

# Tasks to run x2r on the various XML Schema files to produce Ruby
# modules in the XMLOBJ_DIR directory.  The main module is the first
# one (RIFCS.rb), but the other ones are used for testing.

desc "Generate RIF-CS code"
task :generate => [ :generate_rifcs ]

ALL_PARSERS = [
  "#{XMLOBJ_DIR}/RIFCS.rb",
  "#{XMLOBJ_DIR}/AddressBook.rb",
  "#{XMLOBJ_DIR}/XSD.rb",
  "#{XMLOBJ_DIR}/xsd-features/ElementEmpty.rb",
  "#{XMLOBJ_DIR}/xsd-features/ElementRef.rb",
  "#{XMLOBJ_DIR}/xsd-features/Structures.rb",
  "#{XMLOBJ_DIR}/xsd-features/AttributeGroup.rb"
]

desc "Generate all code"
task :generate_all => ALL_PARSERS

RIFCS_XSD = FileList['test/rifcs/xsd/*.xsd']

file "#{XMLOBJ_DIR}/RIFCS.rb" => [ XMLOBJ_DIR, *RIFCS_XSD ] do
  sh %{	bin/x2r -v --module RIFCS,XML --outdir #{XMLOBJ_DIR} #{RIFCS_XSD} }
end

file "#{XMLOBJ_DIR}/AddressBook.rb" => [ XMLOBJ_DIR, 'test/addressbook/addressbook.xsd' ] do |f|
  sh %{	bin/x2r -v --module AddressBook --outdir #{XMLOBJ_DIR} #{f.prerequisites[1]} }
end

file "#{XMLOBJ_DIR}/XSD.rb" => [ XMLOBJ_DIR, 'test/xsd/subset/xsd.xsd', 'test/xsd/subset/xml.xsd' ] do
  sh %{ bin/x2r -v --module XSD,XML --outdir #{XMLOBJ_DIR} test/xsd/subset/xsd.xsd test/xsd/subset/xml.xsd }
end


file "#{XMLOBJ_DIR}/xsd-features/ElementEmpty.rb" => [ "#{XMLOBJ_DIR}/xsd-features", 'test/xsd-features/element-empty/element-empty.xsd' ] do |f|
  sh %{	bin/x2r -v --module ElementEmpty --outdir #{XMLOBJ_DIR}/xsd-features #{f.prerequisites[1]} }
end

file "#{XMLOBJ_DIR}/xsd-features/ElementRef.rb" => [ "#{XMLOBJ_DIR}/xsd-features", 'test/xsd-features/element-ref/element-ref.xsd' ] do |f|
  sh %{	bin/x2r -v --module ElementRef --outdir #{XMLOBJ_DIR}/xsd-features #{f.prerequisites[1]} }
end

file "#{XMLOBJ_DIR}/xsd-features/Structures.rb" => [ "#{XMLOBJ_DIR}/xsd-features", 'test/xsd-features/structures/structures.xsd' ] do |f|
  sh %{	bin/x2r -v --module Structures --outdir #{XMLOBJ_DIR}/xsd-features #{f.prerequisites[1]} }
end

file "#{XMLOBJ_DIR}/xsd-features/AttributeGroup.rb" => [ "#{XMLOBJ_DIR}/xsd-features", 'test/xsd-features/attributeGroup/attributeGroup.xsd' ] do |f|
  sh %{	bin/x2r -v --module AttributeGroup --outdir #{XMLOBJ_DIR}/xsd-features #{f.prerequisites[1]} }
end

#----------------------------------------------------------------
# Tests

task :test => ALL_PARSERS

Rake::TestTask.new do |t|
  t.libs << 'out'
  t.test_files = FileList['test/**/tc*.rb']
  t.verbose = false
  t.warning = true
end

#----------------------------------------------------------------
# Demo

desc 'Test generated parsers by using them to parse/validate examples'
task :demo => [ :d1, :d2, :d3, :d4, :d5 ]

task :d1 => "#{XMLOBJ_DIR}/AddressBook.rb" do |t|
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module AddressBook --verbose test/addressbook/input-01.xml }
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module AddressBook --verbose test/addressbook/input-02.xml }
end

task :d2 => "#{XMLOBJ_DIR}/RIFCS.rb" do |t|
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module RIFCS --verbose test/rifcs/example/input-01.xml }
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module RIFCS --verbose test/rifcs/example/input-02.xml }
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module RIFCS --verbose test/rifcs/example/input-03.xml }
end

task :d3 => "#{XMLOBJ_DIR}/XSD.rb" do |t|
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module XSD --verbose test/addressbook/addressbook.xsd }
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module XSD --verbose test/rifcs/xsd/registryObjects.xsd }
end

task :d4 => "#{XMLOBJ_DIR}/xsd-features/Structures.rb" do |t|
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module Structures --verbose test/xsd-features/structures/input-01.xml }
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module Structures --verbose test/xsd-features/structures/input-02.xml }
  ruby %{ -I #{OUTDIR} bin/xml-tool --parser #{t.prerequisites} --module Structures --verbose test/xsd-features/structures/input-03.xml }
end

task :d5 => "#{XMLOBJ_DIR}/RIFCS.rb" do
  ruby %{ -I #{OUTDIR} bin/rifcs-tool --all test/rifcs/party/input-01.xml }
  ruby %{ -I #{OUTDIR} bin/rifcs-tool --all test/rifcs/party/input-02-name.xml }
end

#----------------------------------------------------------------
# Documentation

RDoc::Task.new do |rd|
  rd.title = 'RIFCS'
  rd.options << '--line-numbers'
  rd.rdoc_files.include "#{XMLOBJ_DIR}/RIFCS.rb"
end

task :rdoc => "#{XMLOBJ_DIR}/RIFCS.rb"

#----------------------------------------------------------------
# Clean and clobber

CLOBBER.include(OUTDIR)

#EOF
