require 'progressive_validators/active_record_changed_validator'

module ProgressiveValidators
  class IntegerOverflowValidator < ActiveRecordChangedValidator

    def validate_changed_attribute(record, attribute)
      column_hash = record.class.columns_hash[attribute]

      if column_hash && column_hash.type == :integer && record[attribute]
        begin
          column_hash.cast_type.type_cast_for_database(record[attribute])
        rescue RangeError => _
          record.errors.add(attribute, (@options[:message] || :out_of_range), default: 'is out of range')
        end
      end
    end

  end
end
