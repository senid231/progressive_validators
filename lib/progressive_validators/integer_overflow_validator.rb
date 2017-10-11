require 'progressive_validators/active_record_changed_validator'

module ProgressiveValidators
  class IntegerOverflowValidator < ActiveRecordChangedValidator

    def validate_changed_attribute(record, attribute)
      column_hash = record.class.columns_hash[attribute]
      value = record[attribute]

      if type_integer?(column_hash) && !value.nil? && !valid_value?(value, column_hash)
        record.errors.add(attribute, :out_of_range, error_options)
      end
    end

    private

    def valid_value?(value, column_hash)
      detect_range(column_hash).cover?(value)
    end

    def type_integer?(column_hash)
      column_hash && column_hash.type == :integer
    end

    def detect_range(column_hash)
      limit = column_hash.limit || 4
      max_value = 1 << (limit * 8 - 1)
      (-max_value...max_value)
    end

  end
end
