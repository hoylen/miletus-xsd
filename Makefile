# Makefile

.PHONY: build doc

BUILD=build
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

XML_TOOL=src/util/xml-tool.rb

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

${BUILD}/AddressBook.rb: \
  ${BUILD}/bootstrap/XSD.rb \
  test/addressbook/addressbook.xsd
	mkdir -p ${BUILD}
	-${X2R} -v --module AddressBook --outdir ${BUILD} \
	   test/addressbook/addressbook.xsd

${BUILD}/RIFCS.rb: \
  ${BUILD}/bootstrap/XSD.rb \
  ${RIFCS_SCHEMAS}
	mkdir -p ${BUILD}
	-${X2R} -v --module RIFCS,XML --outdir ${BUILD} \
	  test/rifcs/xsd/registryTypes.xsd \
	  test/rifcs/xsd/xml.xsd

# Debug dump of the interim parser intermediate output

dump: ${BUILD}/bootstrap/rifcs.rb
	./xsd-debug.rb --preparsed ${BUILD}/bootstrap/rifcs.rb-tmp.rb

#----------------------------------------------------------------

test: \
  test-xsd-features \
  test-addressbook \
  test-rifcs

# XSD features

test-xsd-features: \
  ${BUILD}/bootstrap/xsd-features/ElementEmpty.rb \
  ${BUILD}/bootstrap/xsd-features/AttributeGroup.rb
	ruby -I ${BUILD}/bootstrap -I test \
	  test/xsd-features/ts_xsd-features.rb

test-xsd-features-element-empty: \
  ${BUILD}/bootstrap/xsd-features/ElementEmpty.rb
	ruby -I ${BUILD}/bootstrap \
	  test/xsd-features/element-empty/tc_element-empty.rb

test-xsd-features-attributeGroup: \
  ${BUILD}/bootstrap/xsd-features/attributeGroup.rb
	ruby -I ${BUILD}/bootstrap \
	  test/xsd-features/attributeGroup/tc_attributeGroup.rb


# Address book

test-addressbook: ${BUILD}/bootstrap/AddressBook.rb
	ruby -I ${BUILD}/bootstrap test/addressbook/tc_addressbook.rb

# RIF-CS

test-rifcs: ${BUILD}/bootstrap/RIFCS.rb
	@cd test/rifcs && ruby -I ../../${BUILD}/bootstrap ts.rb

test-rifcs-example: ${BUILD}/bootstrap/RIFCS.rb
	@cd test/rifcs/example && ruby -I ../../../${BUILD}/bootstrap tc.rb

test-rifcs-registryObjects: ${BUILD}/bootstrap/RIFCS.rb
	@cd test/rifcs/registryObjects && ruby -I ../../../${BUILD}/bootstrap tc.rb

test-rifcs-people: ${BUILD}/bootstrap/RIFCS.rb
	@cd test/rifcs/people && ruby -I ../../../${BUILD}/bootstrap tc.rb

#----------------------------------------------------------------
# Parse XML and output XML

test-more: test-rifcs-more test-xsd-more

test-rifcs-more: ${BUILD}/bootstrap/RIFCS.rb
	${XML_TOOL} --parser ${BUILD}/bootstrap/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-01.xml
	${XML_TOOL} --parser ${BUILD}/bootstrap/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-02.xml
	${XML_TOOL} --parser ${BUILD}/bootstrap/RIFCS.rb --module RIFCS --verbose \
	  test/rifcs/example/input-03.xml

test-xsd-more: ${BUILD}/bootstrap/XSD.rb
	${XML_TOOL} --parser ${BUILD}/bootstrap/XSD.rb --module XSD --verbose \
	  test/addressbook/addressbook.xsd
	${XML_TOOL} --parser ${BUILD}/bootstrap/XSD.rb --module XSD --verbose \
	  test/rifcs/xsd/registryObjects.xsd

#----------------------------------------------------------------
# Documentation

doc: \
  ${DOCDIR}/x2r-bootstrap \
  ${DOCDIR}/AddressBook \
  ${DOCDIR}/RIFCS

${DOCDIR}/x2r-bootstrap: src/bootstrap/x2r-bootstrap.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/x2r-bootstrap src/bootstrap/x2r-bootstrap.rb

${DOCDIR}/AddressBook: ${BUILD}/bootstrap/AddressBook.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/addressbook ${BUILD}/bootstrap/AddressBook.rb

${DOCDIR}/RIFCS: ${BUILD}/bootstrap/RIFCS.rb
	mkdir -p ${DOCDIR}
	rdoc -o ${DOCDIR}/rifcs ${BUILD}/bootstrap/RIFCS.rb

#----------------------------------------------------------------
# Clean

clean:
	find . -name \*~ -exec rm {} \;
	rm -rf ${BUILD}
	rm -rf ${DOCDIR}

#EOF
