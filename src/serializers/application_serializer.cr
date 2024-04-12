module Serializers
  class ApplicationSerializer
    @@fields : Array(String) = [] of String
    @@identifier : String = "id"

    def self.serialize(data)
      return serialize(data.to_a) if data.is_a? Granite::AssociationCollection
      return data.map { |dt| parser dt } if data.is_a? Granite::Collection || data.is_a? Array

      parser data
    end

    def self.fields(*fields : Symbol)
      @@fields << @@identifier
      fields.each { |field| @@fields << field.to_s }
    end

    private def self.parser(data)
      data.not_nil!.to_h.select { |key, _value| @@fields.includes? key }
    end
  end
end
