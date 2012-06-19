# Makefile

.PHONY: build doc

BUILDDIR=build
DOCDIR=doc

RIFCS_SCHEMAS=\
test/rifcs/xsd/registryObjects.xsd \
test/rifcs/xsd/activity.xsd \
test/rifcs/xsd/collection.xsd \
test/rifcs/xsd/party.xsd \
test/rifcs/xsd/service.xsd \
test/rifcs/xsd/registryTypes.xsd

default:
	@echo "Targets:"
	@echo "  build"
	@echo "  test"
	@echo "  doc"
	@echo "  clean"
	@echo "  all   - clean build test"

all: clean build test

#----------------------------------------------------------------

build: \
  ${BUILDDIR}/xsd-features/ElementEmpty.rb \
  ${BUILDDIR}/xsd-features/AttributeGroup.rb \
  ${BUILDDIR}/AddressBook.rb \
  ${BUILDDIR}/RIFCS.rb \
  ${BUILDDIR}/XSD.rb

${BUILDDIR}/xsd-features/ElementEmpty.rb: \
  test/xsd-features/element-empty/element-empty.xsd
	mkdir -p ${BUILDDIR}/xsd-features
	./xml-to-code.rb --output $@-tmp.rb \
	  test/xsd-features/element-empty/element-empty.xsd
	./xsd-to-ruby.rb --module ElementEmpty --outdir ${BUILDDIR}/xsd-features --preparsed $@-tmp.rb

${BUILDDIR}/xsd-features/AttributeGroup.rb: \
  test/xsd-features/attributeGroup/attributeGroup.xsd
	mkdir -p ${BUILDDIR}/xsd-features
	./xml-to-code.rb --output $@-tmp.rb \
	  test/xsd-features/attributeGroup/attributeGroup.xsd
	./xsd-to-ruby.rb --module AttributeGroup --outdir ${BUILDDIR}/xsd-features --preparsed $@-tmp.rb

${BUILDDIR}/AddressBook.rb: \
  test/addressbook/addressbook.xsd
	mkdir -p ${BUILDDIR}
	./xml-to-code.rb --output $@-tmp.rb \
	  test/addressbook/addressbook.xsd
	./xsd-to-ruby.rb --module AddressBook --outdir ${BUILDDIR} --preparsed $@-tmp.rb

${BUILDDIR}/RIFCS.rb: ${RIFCS_SCHEMAS}
	mkdir -p ${BUILDDIR}
	./xml-to-code.rb --output $@-tmp.rb ${RIFCS_SCHEMAS}
	./xsd-to-ruby.rb --module RIFCS --outdir ${BUILDDIR} --preparsed $@-tmp.rb

${BUILDDIR}/XSD.rb: test/xsd/subset/xsd.xsd
	mkdir -p ${BUILDDIR}
	./xml-to-code.rb --output $@-tmp.rb test/xsd/subset/xsd.xsd test/xsd/subset/xml.xsd
	./xsd-to-ruby.rb --module XSD,XML --outdir ${BUILDDIR} --preparsed $@-tmp.rb

# Debug dump of the interim parser intermediate output

dump: ${BUILDDIR}/rifcs.rb
	./xsd-debug.rb --preparsed ${BUILDDIR}/rifcs.rb-tmp.rb

#----------------------------------------------------------------

test: \
  test-xsd-features \
  test-addressbook \
  test-rifcs

# XSD features

test-xsd-features: \
  ${BUILDDIR}/xsd-features/ElementEmpty.rb \
  ${BUILDDIR}/xsd-features/AttributeGroup.rb
	ruby -I ${BUILDDIR} -I test \
	  test/xsd-features/ts_xsd-features.rb

test-xsd-features-element-empty: \
  ${BUILDDIR}/xsd-features/ElementEmpty.rb
	ruby -I ${BUILDDIR} \
	  test/xsd-features/element-empty/tc_element-empty.rb

test-xsd-features-attributeGroup: \
  ${BUILDDIR}/xsd-features/attributeGroup.rb
	ruby -I ${BUILDDIR} \
	  test/xsd-features/attributeGroup/tc_attributeGroup.rb


# Address book

test-addressbook: ${BUILDDIR}/AddressBook.rb
	ruby -I ${BUILDDIR} test/addressbook/tc_addressbook.rb

# RIF-CS

test-rifcs: ${BUILDDIR}/RIFCS.rb
	ruby -I ${BUILDDIR} test/rifcs/ts_rifcs.rb

test-rifcs-example: ${BUILDDIR}/RIFCS.rb
	ruby -I ${BUILDDIR} test/rifcs/example/tc_example.rb

test-rifcs-registryObjects: ${BUILDDIR}/RIFCS.rb
	ruby -I ${BUILDDIR} test/rifcs/registryObjects/tc_registryObjects.rb

#----------------------------------------------------------------
# Parse XML and output XML

test-rifcs-more: ${BUILDDIR}/RIFCS.rb
	./xml-test.rb --parser ${BUILDDIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/test-01.xml
	./xml-test.rb --parser ${BUILDDIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/test-02.xml
	./xml-test.rb --parser ${BUILDDIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/test-03.xml

test-xsd-more: ${BUILDDIR}/XSD.rb
	./xml-test.rb --parser ${BUILDDIR}/XSD.rb --module XSD --verbose \
	  test/addressbook/addressbook.xsd

#----------------------------------------------------------------
# Documentation

doc: \
  ${DOCDIR}/xsd-to-ruby \
  ${DOCDIR}/AddressBook \
  ${DOCDIR}/RIFCS

${DOCDIR}/xsd-to-ruby: xsd-to-ruby.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/xsd-to-ruby xsd-to-ruby.rb

${DOCDIR}/AddressBook: ${BUILDDIR}/AddressBook.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/addressbook ${BUILDDIR}/AddressBook.rb

${DOCDIR}/RIFCS: ${BUILDDIR}/RIFCS.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/rifcs ${BUILDDIR}/RIFCS.rb

#----------------------------------------------------------------
# Clean

clean:
	find . -name \*~ -exec rm {} \;
	rm -rf ${BUILDDIR}
	rm -rf ${DOCDIR}

#EOF