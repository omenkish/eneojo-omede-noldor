# frozen_string_literal: true

module ControlledPatch
  # Refine the ruby Hash class to transform object keys.
  refine String do
    def underscore
      self.gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_').downcase
    end
  end

  # Refine the ruby Hash class to transform object keys.
  # This includes the keys from the root hash and from all
  # nested hashes.
  #
  refine Hash do
    # Returns a new hash with all keys converted by the block operation.
    # This includes the keys from the root hash and from all
    # nested hashes.
    #
    #  hash = { person: { name: 'Rob', age: '28' } }
    #
    #  hash.deep_transform_keys{ |key| key.to_s.upcase }
    #  # => {"PERSON"=>{"NAME"=>"Rob", "AGE"=>"28"}}
    def deep_transform_keys(&block)
      result = {}
      each do |key, value|
        result[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys(&block) : value
      end
      result
    end unless method_defined?(:deep_transform_keys)

    # Destructively convert all keys by using the block operation.
    # This includes the keys from the root hash and from all
    # nested hashes.
    def deep_transform_keys!(&block)
      keys.each do |key|
        value = delete(key)
        self[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys!(&block) : value
      end
      self
    end unless method_defined?(:deep_transform_keys!)
  end
end
