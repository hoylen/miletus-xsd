# Makefile

.PHONY: build doc

BUILD=build
XMLOBJ_DIR=${BUILD}/xmlobj
DOCDIR=doc

RIFCS_SCHEMAS=\
test/rifcs/xsd/registryObjects.xsd \
test/rifcs/xsd/activity.xsd \
test/rifcs/xsd/collection.xsd \
test/rifcs/xsd/party.xsd \
test/rifcs/xsd/service.xsd \
test/rifcs/xsd/registryTypes.xsd

BOOTSTRAP_X2C=src/bootstrap/xml-to-code.rb
BOOTSTRAP_X2R=src/bootstrap/x2r-bootstrap.rb

X2R=ruby -I ${BUILD}/bootstrap -I src/x2r  src/x2r/x2r.rb

XML_TOOL=@ruby -I ${BUILD} src/util/xml-tool.rb

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
  ${XMLOBJ_DIR}/XSDPrimitives.rb \
  ${XMLOBJ_DIR}/xsd-features/ElementEmpty.rb \
  ${XMLOBJ_DIR}/xsd-features/AttributeGroup.rb \
  ${XMLOBJ_DIR}/AddressBook.rb \
  ${XMLOBJ_DIR}/RIFCS.rb \
  ${XMLOBJ_DIR}/XSD.rb

${XMLOBJ_DIR}/XSDPrimitives.rb: src/x2r/XSDPrimitives.rb
	mkdir -p ${XMLOBJ_DIR}
	cp $? $@

${XMLOBJ_DIR}/xsd-features/ElementEmpty.rb: \
  ${BUILD}/bootstrap/XSD.rb \
  ${RIFCS_SCHEMAS}
	mkdir -p ${XMLOBJ_DIR}/xsd-features
	-${X2R} -v --module ElementEmpty --outdir ${XMLOBJ_DIR}/xsd-features \
	  test/xsd-features/element-empty/element-empty.xsd

${XMLOBJ_DIR}/xsd-features/AttributeGroup.rb: \
  ${BUILD}/bootstrap/XSD.rb \
  ${RIFCS_SCHEMAS}
	mkdir -p ${XMLOBJ_DIR}/xsd-features
	-${X2R} -v --module AttributeGroup --outdir ${XMLOBJ_DIR}/xsd-features \
	  test/xsd-features/attributeGroup/attributeGroup.xsd

${XMLOBJ_DIR}/AddressBook.rb: \
  ${BUILD}/bootstrap/XSD.rb \
  test/addressbook/addressbook.xsd
	mkdir -p ${XMLOBJ_DIR}
	-${X2R} -v --module AddressBook --outdir ${XMLOBJ_DIR} \
	   test/addressbook/addressbook.xsd

${XMLOBJ_DIR}/RIFCS.rb: \
  ${BUILD}/bootstrap/XSD.rb \
  ${RIFCS_SCHEMAS}
	mkdir -p ${XMLOBJ_DIR}
	-${X2R} -v --module RIFCS,XML --outdir ${XMLOBJ_DIR} \
	  ${RIFCS_SCHEMAS} \
	  test/rifcs/xsd/xml.xsd

${XMLOBJ_DIR}/XSD.rb: \
  ${BUILD}/bootstrap/XSD.rb \
  test/xsd/subset/xsd.xsd
	mkdir -p ${XMLOBJ_DIR}
	-${X2R} -v --module XSD,XML --outdir ${XMLOBJ_DIR} \
	  test/xsd/subset/xsd.xsd test/xsd/subset/xml.xsd

#----------------------------------------------------------------
# Deprecated

bootstrap-examples: \
  ${BUILD}/bootstrap/xsd-features/ElementEmpty.rb \
  ${BUILD}/bootstrap/xsd-features/AttributeGroup.rb \
  ${BUILD}/bootstrap/AddressBook.rb \
  ${BUILD}/bootstrap/RIFCS.rb \
  ${BUILD}/bootstrap/XSD.rb

${BUILD}/bootstrap/xsd-features/ElementEmpty.rb: \
  test/xsd-features/element-empty/element-empty.xsd
	mkdir -p ${BUILD}/bootstrap/xsd-features
	${BOOTSTRAP_X2C} --output $@-tmp.rb \
	  test/xsd-features/element-empty/element-empty.xsd
	${BOOTSTRAP_X2R} --module ElementEmpty --outdir ${BUILD}/bootstrap/xsd-features --preparsed $@-tmp.rb

${BUILD}/bootstrap/xsd-features/AttributeGroup.rb: \
  test/xsd-features/attributeGroup/attributeGroup.xsd
	mkdir -p ${BUILD}/bootstrap/xsd-features
	${BOOTSTRAP_X2C} --output $@-tmp.rb \
	  test/xsd-features/attributeGroup/attributeGroup.xsd
	${BOOTSTRAP_X2R} --module AttributeGroup --outdir ${BUILD}/bootstrap/xsd-features --preparsed $@-tmp.rb

${BUILD}/bootstrap/AddressBook.rb: \
  test/addressbook/addressbook.xsd
	mkdir -p ${BUILD}/bootstrap
	${BOOTSTRAP_X2C} --output $@-tmp.rb \
	  test/addressbook/addressbook.xsd
	${BOOTSTRAP_X2R} --module AddressBook --outdir ${BUILD}/bootstrap --preparsed $@-tmp.rb

${BUILD}/bootstrap/RIFCS.rb: ${RIFCS_SCHEMAS}
	mkdir -p ${BUILD}/bootstrap
	${BOOTSTRAP_X2C} --output $@-tmp.rb ${RIFCS_SCHEMAS}
	${BOOTSTRAP_X2R} --module RIFCS --outdir ${BUILD}/bootstrap --preparsed $@-tmp.rb

${BUILD}/bootstrap/XSD.rb: test/xsd/subset/xsd.xsd
	mkdir -p ${BUILD}/bootstrap
	${BOOTSTRAP_X2C} --output $@-tmp.rb test/xsd/subset/xsd.xsd test/xsd/subset/xml.xsd
	${BOOTSTRAP_X2R} --module XSD,XML --outdir ${BUILD}/bootstrap --preparsed $@-tmp.rb

new: ${BUILD}/AddressBook.rb
	ruby -I ${BUILD} test/addressbook/tc_addressbook.rb

# Debug dump of the bootstrap intermediate output

dump-addressbook: ${BUILD}/bootstrap/AddressBook.rb
	src/bootstrap/xsd-debug.rb --preparsed ${BUILD}/bootstrap/AddressBook.rb-tmp.rb

dump-rifcs: ${BUILD}/bootstrap/RIFCS.rb
	src/bootstrap/xsd-debug.rb --preparsed ${BUILD}/bootstrap/RIFCS.rb-tmp.rb

dump-xsd: ${BUILD}/bootstrap/XSD.rb
	src/bootstrap/xsd-debug.rb --preparsed ${BUILD}/bootstrap/XSD.rb-tmp.rb

#----------------------------------------------------------------

test: \
  test-xsd-features \
  test-addressbook \
  test-rifcs

# XSD features

test-xsd-features: \
  ${XMLOBJ_DIR}/xsd-features/ElementEmpty.rb \
  ${XMLOBJ_DIR}/xsd-features/AttributeGroup.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	ruby -I ${BUILD} -I test \
	  test/xsd-features/ts_xsd-features.rb

test-xsd-features-element-empty: \
  ${XMLOBJ_DIR}/xsd-features/ElementEmpty.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	ruby -I ${BUILD} \
	  test/xsd-features/element-empty/tc_element-empty.rb

test-xsd-features-attributeGroup: \
  ${XMLOBJ_DIR}/xsd-features/AttributeGroup.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	ruby -I ${BUILD} \
	  test/xsd-features/attributeGroup/tc_attributeGroup.rb


# Address book

test-addressbook: \
  ${XMLOBJ_DIR}/AddressBook.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	ruby -I ${BUILD} test/addressbook/tc_addressbook.rb

# RIF-CS

test-rifcs: \
  ${XMLOBJ_DIR}/RIFCS.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	@cd test/rifcs && ruby -I ../../${BUILD} ts.rb

test-rifcs-example: \
  ${XMLOBJ_DIR}/RIFCS.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	@cd test/rifcs/example && ruby -I ../../../${BUILD} tc.rb

test-rifcs-registryObjects: \
  ${XMLOBJ_DIR}/RIFCS.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	@cd test/rifcs/registryObjects && ruby -I ../../../${BUILD} tc.rb

test-rifcs-party: \
  ${XMLOBJ_DIR}/RIFCS.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	@cd test/rifcs/party && ruby -I ../../../${BUILD} tc.rb

#----------------------------------------------------------------
# Parse XML and output XML

test-more: test-rifcs-more test-xsd-more

test-rifcs-more: \
  ${XMLOBJ_DIR}/RIFCS.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	${XML_TOOL} --parser ${XMLOBJ_DIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-01.xml
	${XML_TOOL} --parser ${XMLOBJ_DIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-02.xml
	${XML_TOOL} --parser ${XMLOBJ_DIR}/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-03.xml

test-xsd-more: \
  ${XMLOBJ_DIR}/XSD.rb \
  ${XMLOBJ_DIR}/XSDPrimitives.rb
	${XML_TOOL} --parser ${XMLOBJ_DIR}/XSD.rb --module XSD --verbose \
	  test/addressbook/addressbook.xsd
	${XML_TOOL} --parser ${XMLOBJ_DIR}/XSD.rb --module XSD --verbose \
	  test/rifcs/xsd/registryObjects.xsd

#----------------------------------------------------------------
# Documentation

doc: \
  ${DOCDIR}/x2r-bootstrap \
  ${DOCDIR}/x2r \
  ${DOCDIR}/AddressBook \
  ${DOCDIR}/RIFCS

${DOCDIR}/x2r-bootstrap: src/bootstrap/x2r-bootstrap.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/x2r-bootstrap src/bootstrap/x2r-bootstrap.rb

${DOCDIR}/x2r:
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/x2r src/x2r/*.rb

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
