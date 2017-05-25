class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  class << self
    protected

    def enum_with_string_values(enum_definitions)
      enum_definitions.keys.each do |enum_attribute_name|
        enum_definitions[enum_attribute_name] = enum_definitions[enum_attribute_name].
                                                each_with_object({}) { |enum_value, hash| hash[enum_value] = enum_value.to_s }
      end
      enum(enum_definitions)
    end
  end
end
