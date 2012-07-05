# Makefile

.PHONY: build doc

BUILD=out
XMLOBJ_DIR=${BUILD}/xmlobj
DOCDIR=doc

RIFCS_SCHEMAS=\
test/rifcs/xsd/registryObjects.xsd \
test/rifcs/xsd/activity.xsd \
test/rifcs/xsd/collection.xsd \
test/rifcs/xsd/party.xsd \
test/rifcs/xsd/service.xsd \
test/rifcs/xsd/registryTypes.xsd


X2R=bin/x2r

XML_TOOL=@ruby -I ${BUILD} bin/xml-tool

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
  ${XMLOBJ_DIR}/xsd-features/ElementEmpty.rb \
  ${XMLOBJ_DIR}/xsd-features/AttributeGroup.rb \
  ${XMLOBJ_DIR}/AddressBook.rb \
  ${XMLOBJ_DIR}/RIFCS.rb \
  ${XMLOBJ_DIR}/XSD.rb

${XMLOBJ_DIR}/xsd-features/ElementEmpty.rb: \
  test/xsd-features/element-empty/element-empty.xsd
	mkdir -p ${XMLOBJ_DIR}/xsd-features
	-${X2R} -v --module ElementEmpty --outdir ${XMLOBJ_DIR}/xsd-features \
	  test/xsd-features/element-empty/element-empty.xsd

${XMLOBJ_DIR}/xsd-features/AttributeGroup.rb: \
  test/xsd-features/attributeGroup/attributeGroup.xsd
	mkdir -p ${XMLOBJ_DIR}/xsd-features
	-${X2R} -v --module AttributeGroup --outdir ${XMLOBJ_DIR}/xsd-features \
	  test/xsd-features/attributeGroup/attributeGroup.xsd

${XMLOBJ_DIR}/xsd-features/Structures.rb: \
  test/xsd-features/structures/structures.xsd
	mkdir -p ${XMLOBJ_DIR}/xsd-features
	-${X2R} -v --module Structures --outdir ${XMLOBJ_DIR}/xsd-features \
	  test/xsd-features/structures/structures.xsd

${XMLOBJ_DIR}/AddressBook.rb: \
  test/addressbook/addressbook.xsd
	mkdir -p ${XMLOBJ_DIR}
	-${X2R} -v --module AddressBook --outdir ${XMLOBJ_DIR} \
	   test/addressbook/addressbook.xsd

${XMLOBJ_DIR}/RIFCS.rb: \
  ${RIFCS_SCHEMAS}
	mkdir -p ${XMLOBJ_DIR}
	-${X2R} -v --module RIFCS,XML --outdir ${XMLOBJ_DIR} \
	  ${RIFCS_SCHEMAS} \
	  test/rifcs/xsd/xml.xsd

${XMLOBJ_DIR}/XSD.rb: \
  test/xsd/subset/xsd.xsd
	mkdir -p ${XMLOBJ_DIR}
	-${X2R} -v --module XSD,XML --outdir ${XMLOBJ_DIR} \
	  test/xsd/subset/xsd.xsd test/xsd/subset/xml.xsd

#----------------------------------------------------------------
# Deprecated


#----------------------------------------------------------------

test: \
  test-xsd-features \
  test-addressbook \
  test-rifcs

# XSD features

test-xsd-features: \
  ${XMLOBJ_DIR}/xsd-features/ElementEmpty.rb \
  ${XMLOBJ_DIR}/xsd-features/AttributeGroup.rb \
  ${XMLOBJ_DIR}/xsd-features/Structures.rb
	ruby -I ${BUILD} \
	  test/xsd-features/ts_xsd-features.rb

test-xsd-features-element-empty: \
  ${XMLOBJ_DIR}/xsd-features/ElementEmpty.rb
	ruby -I ${BUILD} \
	  test/xsd-features/element-empty/tc_element-empty.rb

test-xsd-features-attributeGroup: \
  ${XMLOBJ_DIR}/xsd-features/AttributeGroup.rb
	ruby -I ${BUILD} \
	  test/xsd-features/attributeGroup/tc_attributeGroup.rb

test-xsd-features-structures: \
  ${XMLOBJ_DIR}/xsd-features/Structures.rb
	ruby -I ${BUILD} \
	  test/xsd-features/structures/tc_structures.rb


# Address book

test-addressbook: \
  ${XMLOBJ_DIR}/AddressBook.rb
	ruby -I ${BUILD} test/addressbook/tc_addressbook.rb

# RIF-CS

test-rifcs: \
  ${XMLOBJ_DIR}/RIFCS.rb
	ruby -I ${BUILD} test/rifcs/ts.rb

test-rifcs-example: \
  ${XMLOBJ_DIR}/RIFCS.rb
	ruby -I ${BUILD} test/rifcs/example/tc.rb

test-rifcs-registryObjects: \
  ${XMLOBJ_DIR}/RIFCS.rb
	ruby -I ${BUILD} test/rifcs/registryObjects/tc.rb

test-rifcs-party: \
  ${XMLOBJ_DIR}/RIFCS.rb
	ruby -I ${BUILD} test/rifcs/party/tc.rb

#----------------------------------------------------------------
# Parse XML and output XML

test-more: test-addressbook-more test-rifcs-more test-xsd-more

test-xsd-features-more: \
  ${XMLOBJ_DIR}/xsd-features/Structures.rb
	${XML_TOOL} --parser ${XMLOBJ_DIR}/xsd-features/Structures.rb --module Structures --verbose \
	  test/xsd-features/structures/input-01.xml
	${XML_TOOL} --parser ${XMLOBJ_DIR}/xsd-features/Structures.rb --module Structures --verbose \
	  test/xsd-features/structures/input-02.xml
	${XML_TOOL} --parser ${XMLOBJ_DIR}/xsd-features/Structures.rb --module Structures --verbose \
	  test/xsd-features/structures/input-03.xml

test-addressbook-more: \
  ${XMLOBJ_DIR}/AddressBook.rb
	${XML_TOOL} --parser ${XMLOBJ_DIR}/AddressBook.rb --module AddressBook --verbose \
	  test/addressbook/input-01.xml
	${XML_TOOL} --parser ${XMLOBJ_DIR}/AddressBook.rb --module AddressBook --verbose \
	  test/addressbook/input-02.xml

test-rifcs-more: \
  ${XMLOBJ_DIR}/RIFCS.rb
	${XML_TOOL} --parser ${XMLOBJ_DIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-01.xml
	${XML_TOOL} --parser ${XMLOBJ_DIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-02.xml
	${XML_TOOL} --parser ${XMLOBJ_DIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-03.xml

test-xsd-more: \
  ${XMLOBJ_DIR}/XSD.rb
	${XML_TOOL} --parser ${XMLOBJ_DIR}/XSD.rb --module XSD --verbose \
	  test/addressbook/addressbook.xsd
	${XML_TOOL} --parser ${XMLOBJ_DIR}/XSD.rb --module XSD --verbose \
	  test/rifcs/xsd/registryObjects.xsd


#----------------------------------------------------------------
# Parse RIFCS

test-high: \
  ${XMLOBJ_DIR}/RIFCS.rb
	ruby -I ${BUILD} bin/rifcs-tool --all test/rifcs/party/input-01.xml
	ruby -I ${BUILD} bin/rifcs-tool --all test/rifcs/party/input-02-name.xml

#----------------------------------------------------------------
# Documentation

doc: \
  ${DOCDIR}/x2r-bootstrap \
  ${DOCDIR}/x2r \
  ${DOCDIR}/AddressBook \
  ${DOCDIR}/RIFCS

${DOCDIR}/x2r-bootstrap: bin/bootstrap/x2r-bootstrap.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/x2r-bootstrap bin/bootstrap/x2r-bootstrap.rb

${DOCDIR}/x2r:
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/x2r bin/x2r/*.rb

${DOCDIR}/AddressBook: ${XMLOBJ_DIR}/AddressBook.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/addressbook ${XMLOBJ_DIR}/AddressBook.rb

${DOCDIR}/RIFCS: ${XMLOBJ_DIR}/RIFCS.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/rifcs ${XMLOBJ_DIR}/RIFCS.rb

#----------------------------------------------------------------
# Clean

clean:
	find . -name \*~ -exec rm {} \;
	rm -rf ${BUILD}
	rm -rf ${DOCDIR}

#EOF
