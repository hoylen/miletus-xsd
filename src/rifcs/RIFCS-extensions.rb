#!/usr/bin/env ruby

# Additional methods to make handling RIF-CS easier.

$VERBOSE = true

module RIFCS

  class DataElementIterator
    def initialize(record, name)
      @record = record
      @filter = name
    end

    def each
      if @filter.is_a? Symbol
        # Only process matching data elements
        @record._choices.each do |ch|
          value = ch[@filter]
          if value
            yield(value)
          end
        end

      elsif @filter.is_a? Array
        # Process all data elements
        @filter.each do |f|
          @record._choices.each do |ch|
            value = ch[f]
            if value
              yield(value)
            end
          end
        end
      else
        raise # @filter was incorrectly initialized
      end
    end
  end

  # Party

  class ComplexType__anon11
    def identifier;     return DataElementIterator.new(self, :identifier); end
    def name;           return DataElementIterator.new(self, :name); end
    def location;       return DataElementIterator.new(self, :location); end
    def coverage;       return DataElementIterator.new(self, :coverage); end
    def relatedObject;  return DataElementIterator.new(self, :relatedObject); end
    def subject;        return DataElementIterator.new(self, :subject); end
    def description;    return DataElementIterator.new(self, :description); end
    def rights;         return DataElementIterator.new(self, :rights); end
    def existenceDates; return DataElementIterator.new(self, :existenceDates); end
    def relatedInfo;    return DataElementIterator.new(self, :relatedInfo); end
    def all;            return DataElementIterator.new(self, Choice__anon12::NAMES); end
  end

  # Collection

  class ComplexType__anon9
    def identifier;     return DataElementIterator.new(self, :identifier); end
    def name;           return DataElementIterator.new(self, :name); end
    def location;       return DataElementIterator.new(self, :location); end
    def coverage;       return DataElementIterator.new(self, :coverage); end
    def relatedObject;  return DataElementIterator.new(self, :relatedObject); end
    def subject;        return DataElementIterator.new(self, :subject); end
    def description;    return DataElementIterator.new(self, :description); end
    def rights;         return DataElementIterator.new(self, :rights); end
    def relatedInfo;    return DataElementIterator.new(self, :relatedInfo); end
    def citationInfo;   return DataElementIterator.new(self, :citationInfo); end
    def all;            return DataElementIterator.new(self, Choice__anon10::NAMES); end
  end

  # Activity

  # Service

end

=begin
class RIFCS

  class RegistryObject
    # String value
    attr_accessor :key
    # String value
    attr_accessor :originatingSource
    # Optional (could be +nil+).
    attr_accessor :group

    # Mandatory string
    attr_accessor :type
    # Optional string
    attr_accessor :dateModified

    def initialize
      @key = nil
      @originatingSource = nil
      @group = nil
      @type = nil
      @dateModified = nil
    end

    def check(strict)
      raise 'RegistryObject: key not set' if ! @key
      raise 'RegistryObject: originatingSource not set' if ! @originatingSource
      raise 'RegistryObject: type not set' if ! @type

      if (strict)
        raise 'RegistryObject: key not a String' if ! @key.is_a?(String)
        raise 'RegistryObject: originatingSource not a String' if ! @originatingSource.is_a?(String)
        if @group
          raise 'RegistryObject: group not a String' if ! @group.is_a?(String)
        end
        raise 'RegistryObject: type not a String' if ! @type.is_a?(String)
        if @dateModified
          raise 'RegistryObject: dateModified not a String' if ! @dateModified.is_a?(String)
        end
      end
    end
  end

  #----------------------------------------------------------------

  # Represents an ISO2146 collections and services registry Party object.

  class Party < RegistryObject

    # Primary and alternative identifiers for a party. The value of
    # the _key_ element may be repeated, or any additional
    # (local or global) identifiers described. Each identifier must be
    # represented in its own identifier element.
    attr_accessor :identifier

    # The name of the party in either a simple or compound form.
    attr_accessor :name

    # Location(s) relevant to the party. A location element should
    # contain information about a single location (e.g. home address).
    attr_accessor :location

    # Party coverage information.
    attr_accessor :coverage

    # Element for holding information about a related registry object.
    attr_accessor :relatedObject

    #A subject category into which the party falls or the party is related. Multiple subjects must be represented via separate subject elements. 
    attr_accessor :subject

    # A textual description or URI resolving to a description relevant to the party.
    attr_accessor :description

    # Rights(s) relevant to the collection.
    attr_accessor :rights

    # Element for holding a start date and end date.
    attr_accessor :existenceDates

    # A URI pointing to information related to the party.
    attr_accessor :relatedInfo

    def initialize
      super()
      @identifier = []
      @name = []
      @location = []
      @coverage = []
      @relatedObject = []
      @subject = []
      @description = []
      @rights = []
      @existenceDates = []
      @relatedInfo = []
    end

    def check(strict)
      super(strict)
      if strict
        @identifier.each { |x| raise 'party: identifier is not an Identifier' if ! x.is_a(Identifier) }
        @name.each { |x| raise 'party: name is not a Name' if ! x.is_a?(Name) }
        @location.each { |x| raise 'party: location is not a Location' if ! x.is_a?(Location) }
        @coverage.each { |x| raise 'party: coverage is not a Coverage' if ! x.is_a?(Coverage) }
        @relatedObject.each { |x| raise 'party: relatedObject is not a RelatedObject' if ! x.is_a?(RelatedObject) }
        @subject.each { |x| raise 'party: subject is not a Subject' if ! x.is_a?(Subject) }
        @description.each { |x| raise 'party: description is not a Description' if ! x.is_a?(Description) }
        @rights.each { |x| raise 'party: rights is not a Rights' if ! x.is_a?(Rights) }
        @existenceDates.each { |x| raise 'party: existenceDates is not an ExistenceDates' if ! x.is_a?(ExistenceDates) }
        @relatedInfo.each { |x| raise 'party: relatedInfo is not a RelatedInfo' if ! x.is_a?(RelatedInfo) }
      end
    end

  end

  class Identifier
    attr_accessor :value
    # Mandatory type
    attr_accessor :type

    def check(strict)
      raise 'Identifier: value not set' if ! @value
      raise 'Identifier: type not set' if ! @type

      if (strict)
        raise 'Identifier: value not a String' if ! @value.is_a?(String)
        raise 'Identifier: type not a String' if ! @type.is_a?(String)
      end
    end
  end

  class Name
    attr_accessor :name_parts
    # Optional type
    attr_accessor :type
    # Optional dateFrom
    attr_accessor :dateFrom
    # Optional dateTo
    attr_accessor :dateTo

    def initialize
      @name_parts = []
    end

    def check(strict)
      raise 'Name: no date parts' if @name_parts.empty?

      if (strict)
        raise 'Name: namePart not a NamePart' if ! @namePart.is_a?(NamePart)
        raise 'type: type not a String' if ! @type.is_a?(String)
        raise 'type: dateFrom not a String' if ! @dateFrom.is_a?(String)
        raise 'type: dateTo not a String' if ! @dateTo.is_a?(String)
      end
    end
  end

  # Either a single string (using one &lt;namePart&gt; element) or the
  # name represented in compound form with the content of each
  # namePart being described by the type attribute.

  class NamePart
    attr_accessor :value
    # Optional type
    attr_accessor :type

    def initialize
      @value = nil
      @type = nil
    end

    def check(strict)
      raise 'NamePart: no value' if ! @value

      if (strict)
        raise 'type: value not a String' if ! @value.is_a?(String)
        raise 'type: type not a String' if ! @type.is_a?(String)
      end
    end

  end

  class Location
  end

  class Coverage
  end

  class RelatedObject
  end

  class Subject
  end

  class Description
  end

  class Rights
  end

  class ExistenceDates
  end

end



p = RIFCS::Party.new
p.key = '123'
p.originatingSource = 'http://example.com/'
p.type = 'person'
p.check(true)
=end


#EOF
