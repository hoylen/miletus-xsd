# Makefile

VALIDATE=@xmllint --schema ${XSD} --noout

SCHEMAS=\
../addressbook/addressbook.xsd \
../xsd-features/attributeGroup/attributeGroup.xsd \
../xsd-features/element-empty/element-empty.xsd \
../xsd-features/element-ref/element-ref.xsd \
../rifcs/xsd/activity.xsd \
../rifcs/xsd/collection.xsd \
../rifcs/xsd/party.xsd \
../rifcs/xsd/registryObjects.xsd \
../rifcs/xsd/registryTypes.xsd \
../rifcs/xsd/service.xsd \
../rifcs/xsd/xml.xsd \
./subset/xsd.xsd \
./subset/xml.xsd

default:
	@echo "Targets:"
	@echo "  reality - check current schemas work"
	@echo "  utopia  - check full schema for schema (this will not work yet)"

reality: check-full check-subset

# Validate all schemas (except for the full schema for schemas)
# against the full schema for schemas. Success means the
# schemas (including the subset of schema for schemas) are
# schema valid against the standard.

check-full:
	@XSD=full/xsd.xsd ; \
	echo "Validating against $${XSD}" ; \
	for S in ${SCHEMAS}; do \
	  xmllint --schema $${XSD} --noout $$S ; \
	done
	@echo

# Validate all schemas (except for the full schema for schemas)
# against the subset of schema for schemas. Success means the
# schemas (including the subset of schema for schemas) can be
# parsed by our schema parser (which is built using this
# subset schema for schemas).

check-subset:
	@XSD=subset/xsd.xsd ; \
	echo "Validating against $${XSD}" ; \
	for S in ${SCHEMAS}; do \
	  xmllint --schema $${XSD} --noout $$S ; \
	done
	@echo

# The aim is to add to the subset schema for schemas to
# improve the range of schemas the parser can handle.
# The ultimate goal is to end up with the subset being
# complete; and to use the full schema for schema to
# generate the parser.

FULL_SCHEMA_FOR_SCHEMAS=\
./full/datatypes.xsd \
./full/xsd.xsd \
./full/xml.xsd

utopia:
	@XSD=subset/xsd.xsd ; \
	echo "Validating against $${XSD}" ; \
	for S in ${FULL_SCHEMA_FOR_SCHEMAS}; do \
	  xmllint --schema $${XSD} --noout $$S ; \
	done

#EOF
