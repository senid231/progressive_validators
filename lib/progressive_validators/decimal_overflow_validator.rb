require 'progressive_validators/active_record_changed_validator'

module ProgressiveValidators
  class DecimalOverflowValidator < ActiveRecordChangedValidator

    def detect_precision(column_hash, record, attribute)
      # The precision of a numeric is the total count of significant digits in the whole number, that is,
      # the number of digits to both sides of the decimal point
      if column_hash.scale.nil?
        # in case when scale is nil, precision can't be greater than count of all digits in number
        record[attribute].to_s.gsub('.', '').size
      else
        # BigDecimal#exponent is an decimal numbers count to the left of decimal point
        # in case when scale is not nil, (precision - scale) can't be greater than count of digist to the left of decimal point
        record[attribute].exponent + column_hash.scale
      end
    end

    def validate_changed_attribute(record, attribute)
      column_hash = record.class.columns_hash[attribute]

      if column_hash && column_hash.type == :decimal && record[attribute] && column_hash.precision
        precision = detect_precision(column_hash, record, attribute)

        if precision > column_hash.precision
          record.errors.add(attribute, (@options[:message] || :out_of_range), default: 'is out of range')
        end
      end
    end

  end
end
