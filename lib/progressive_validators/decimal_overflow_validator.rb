require 'progressive_validators/active_record_changed_validator'

module ProgressiveValidators
  class DecimalOverflowValidator < ActiveRecordChangedValidator
    DEFAULT_PRECISION = 131072
    DEFAULT_SCALE = 16383

    def validate_changed_attribute(record, attribute)
      column_hash = record.class.columns_hash[attribute]
      value = record[attribute]

      if type_decimal?(column_hash) && !value.nil? && !valid_value?(value, column_hash)
        record.errors.add(attribute, :out_of_range, error_options)
      end
    end

    private

    def valid_value?(value, column_hash)
      _sign, digits, _base, exponent = value.to_d.split
      precision = exponent
      scale = digits == '0' ? 0 : (digits.length - exponent)

      if column_hash.precision.nil?
        # up to 131072 digits before the decimal point; up to 16383 digits after the decimal point
        max_precision = DEFAULT_PRECISION
        max_scale = DEFAULT_SCALE
      else
        # The scale of a numeric is the count of decimal digits in the fractional part, to the right of the decimal point.
        # The precision of a numeric is the total count of significant digits in the whole number,
        # that is, the number of digits to both sides of the decimal point.
        # On typecasting value is rounded
        max_precision = column_hash.precision
        max_scale = column_hash.scale || 0
        precision += scale
      end

      precision <= max_precision && scale <= max_scale
    end

    def bigdecimal_scale(value)
      _sign, digits, _base, exponent = value.split
      digits.length - exponent
    end

    def type_decimal?(column_hash)
      column_hash && column_hash.type == :decimal
    end

  end
end
