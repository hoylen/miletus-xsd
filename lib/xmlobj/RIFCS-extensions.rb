#!/usr/bin/env ruby

# Additional methods to make handling RIF-CS easier.

$VERBOSE = true

module RIFCS

  # An iterator that hides the complicated choice[0..*]/element[0..*] of
  # RIF-CS from the user. They can simply access particular data elements
  # of the metadata record, ignoring how they might be scattered in
  # the metadata record.
 
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
        @filter.each do |data_element|
          @record._choices.each do |ch|
            value = ch[data_element]
            if value
              value.each do |v|
                yield(v)
              end
            end
          end
        end
      else
        raise # @filter was incorrectly initialized
      end
    end
  end

  # Party

  class ComplexType_for_party
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
    def all;            return DataElementIterator.new(self, Choice_in_ComplexType_for_party::NAMES); end
  end

  # Collection

  class ComplexType_for_collection
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
    def all;            return DataElementIterator.new(self, Choice_in_ComplexType_for_collection::NAMES); end
  end

  # Activity

  # Service

end

#EOF
